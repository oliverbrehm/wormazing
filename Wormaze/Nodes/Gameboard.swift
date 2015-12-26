//
//  Gameboard.swift
//  Wormaze
//
//  Created by Oliver Brehm on 25.12.15.
//  Copyright © 2015 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class GameBoard: SKNode {
    static var tileSize: CGFloat = 15.0
    static let growingTime = 10 // steps
    
    var players: [Player] = []
    var growTimer = 0 // steps
    var gameStarted = false
    
    var collectables: [Collectable] = []
    
    var timeOutStart = 0.0
    
    let timeOutLenghth = 1.0
    
    var tilesX: Int = 0
    var tilesY: Int = 0
    
    var size : CGSize = CGSize(width: 0.0, height: 0.0)
    
    let gameOverNode = SKSpriteNode(color: NSColor.redColor(), size: CGSize(width: 0.0 ,height: 0.0))
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(tilesX: Int, tilesY: Int) {
        self.tilesX = tilesX
        self.tilesY = tilesY
        super.init()
        
    }
    
    func initialize(size: CGSize)
    {
        self.size = size
        GameBoard.tileSize = min(self.size.width / CGFloat(self.tilesX), self.size.height / CGFloat(self.tilesY))
        self.size = CGSize(width: CGFloat(self.tilesX) * GameBoard.tileSize, height: CGFloat(self.tilesY) * GameBoard.tileSize)
        
        // frame
        let frame = SKSpriteNode(color: NSColor.greenColor(), size: self.size);
        frame.alpha = 0.2
        frame.position = CGPoint(x: 0.0, y: 0.0)
        frame.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.addChild(frame)
        
        // game over node
        self.gameOverNode.size = frame.size
        self.gameOverNode.position = CGPoint(x: 0.0, y: 0.0)
        self.gameOverNode.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.gameOverNode.alpha = 0.6
        
        // debug
        let test1 = SKSpriteNode(color: SKColor.brownColor(), size: CGSize(width: 5, height: 5))
        test1.position = CGPoint(x: 0.0, y: 0.0)
        test1.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.addChild(test1)
        
        let test2 = SKSpriteNode(color: SKColor.brownColor(), size: CGSize(width: 5, height: 5))
        test2.position = CGPoint(x: self.size.width, y: self.size.height)
        test2.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        self.addChild(test2)
    }
    
    func anyKeyHit(currentTime: CFTimeInterval) {
        if(!gameStarted && currentTime > self.timeOutStart + self.timeOutLenghth) {
            newGame()
            startGame()
        }
    }
    
    func newGame()
    {
        for player in self.players {
            player.removeTiles()
            player.removeFromParent()
        }
        
        self.players.removeAll()
        
        gameOverNode.removeFromParent()
        let player1 = Player(x: 1, y: 3, color: SKColor.greenColor(), gameBoard: self)
        self.players.append(player1)
        
        let player2 = Player(x: 1, y: 20, color: SKColor.orangeColor(), gameBoard: self)
        self.players.append(player2)
        
        for collectable in self.collectables {
            collectable.removeFromParent()
        }
        self.collectables.removeAll()
        self.spawnItem()
    }
    
    func startGame()
    {
        gameStarted = true
    }
    
    func spawnItem()
    {
        var x, y : Int
        let maxTries = self.tilesX * self.tilesY
        var tries = 0
        
        repeat {
            x = Int(arc4random()) % self.tilesX
            y = Int(arc4random()) % self.tilesY
            tries++
        } while(self.pointOccupied(x, y: y) && tries < maxTries)
        
        if(tries == maxTries) {
            return
        }
        
        let collectable = Collectable(x: x, y: y)
        print("SPAWN(\(x),\(y))")
        self.collectables.append(collectable)
        self.addChild(collectable)
    }
    
    func gameOver(loser: Int)
    {
        gameOverNode.removeAllChildren()
        self.addChild(gameOverNode)
        
        let label : SKLabelNode

        if(loser == 1) {
            label = SKLabelNode(text: "Green wins!")
        } else {
            label = SKLabelNode(text: "Orange wins!")
        }
        
        label.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        gameOverNode.addChild(label)
        
        gameStarted = false
    }
    
    func hitItem(x: Int, y: Int) -> Bool {
        var toRemove : Collectable? = nil
        
        for collectable in self.collectables {
            if(collectable.x == x && collectable.y == y) {
                toRemove = collectable
                break
            }
        }
        
        if(toRemove != nil) {
            toRemove!.removeFromParent()
            self.collectables.removeAtIndex(self.collectables.indexOf(toRemove!)!)
            return true
        }
        
        return false
    }
    
    func pointOccupied(x: Int, y: Int) -> Bool
    {
        for player in self.players {
            if(player.occupiesPoint(x, y: y)) {
                return true
            }
        }
        
        return false
    }
    
    func update(currentTime: CFTimeInterval)
    {
        if(!gameStarted) {
            return;
        }
        
        let grow = growTimer >= GameBoard.growingTime
        if(grow) {
            growTimer = 0
        }
        
        for(var i = 0; i < players.count; i++) {
            let player = players[i]
            if(player.step()) {
                gameOver(i)
                self.timeOutStart = currentTime
                break
            }
            
            if(grow) {
                player.grow(1)
            }
        }
        
        growTimer++
    }
}