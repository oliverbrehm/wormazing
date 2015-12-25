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
    static let tileSize: CGFloat = 15.0
    static let growingTime = 5 // steps
    
    var players: [Player] = []
    var growTimer = 0 // steps
    var gameStarted = false
    
    var tilesX: Int = 0
    var tilesY: Int = 0
    
    let gameOverNode = SKSpriteNode(color: NSColor.redColor(), size: CGSize(width: 200, height: 200))
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(tilesX: Int, tilesY: Int) {
        self.tilesX = tilesX
        self.tilesY = tilesY
        super.init()
        
    }
    
    func initialize()
    {
        // frame
        let frame = SKSpriteNode(color: NSColor.blueColor(), size: CGSize(width: GameBoard.tileSize * CGFloat(tilesX), height: GameBoard.tileSize * CGFloat(tilesY)));
        frame.alpha = 0.2
        frame.position = CGPoint(x: 0.0, y: 0.0)
        frame.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.addChild(frame)
        
        // debug
        let test1 = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 50, height: 50))
        test1.position = CGPoint(x: 0.0, y: 0.0)
        test1.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.addChild(test1)
        
        let test2 = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 50, height: 50))
        test2.position = CGPoint(x: GameBoard.tileSize * CGFloat(tilesX), y: GameBoard.tileSize * CGFloat(tilesY))
        test2.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        self.addChild(test2)
    }
    
    override func keyDown(theEvent: NSEvent) {
        if(!gameStarted) {
            newGame()
            startGame()
        }
    }
    
    func newGame()
    {
        gameOverNode.removeFromParent()
        let player1 = Player(x: 1, y: 3, color: SKColor.greenColor(), gameBoard: self)
        self.players.append(player1)
        
        let player2 = Player(x: 1, y: 20, color: SKColor.orangeColor(), gameBoard: self)
        self.players.append(player2)
    }
    
    func startGame()
    {
        gameStarted = true
    }
    
    func gameOver()
    {
        gameOverNode.position = CGPoint(x: 300, y: 300)
        self.addChild(gameOverNode)
        
        for player in self.players {
            player.removeTiles()
            player.removeFromParent()
        }
        
        self.players.removeAll()
        
        gameStarted = false
    }
    
    func update()
    {
        if(!gameStarted) {
            return;
        }
        
        let grow = growTimer >= GameBoard.growingTime
        if(grow) {
            growTimer = 0
        }
        
        for player in self.players {
            if(player.step()) {
                gameOver()
                break
            }
            
            if(grow) {
                player.grow()
            }
        }
        
        growTimer++
    }
}