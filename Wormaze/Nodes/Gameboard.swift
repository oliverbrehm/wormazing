//
//  Gameboard.swift
//  Wormaze
//
//  Created by Oliver Brehm on 25.12.15.
//  Copyright © 2015 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

protocol GameBoardDelegate
{
    func gameBoardGameOver(score: Int?, message: String, color: SKColor)
    func gameBoardPaused()
}

class GameBoard: SKSpriteNode {
    static var tileSize: CGFloat = 15.0
    static let growingTime = 10 // steps
    
    var delegate : GameBoardDelegate?
    
    var players: [Player] = []
    
    var growTimer = 0 // steps
    var running = false
    
    var collectables: [Collectable] = []
    
    var tilesX: Int = 0
    var tilesY: Int = 0
    
    let gameOverNode = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 0.0 ,height: 0.0))
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        self.tilesX = 0
        self.tilesY = 0
        super.init(texture: nil, color: GameView.gameColors.background, size: CGSizeZero)
    }
    
    func initialize(size: CGSize)
    {
        self.zPosition = GameScene.zPositions.Background
        self.size = size
        GameBoard.tileSize = Tile.texture.size().width
        
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        
        self.tilesX = Int(self.size.width / GameBoard.tileSize)
        self.tilesY = Int(self.size.height / GameBoard.tileSize)

        self.size.width = CGFloat(self.tilesX) * GameBoard.tileSize
        self.size.height = CGFloat(self.tilesY) * GameBoard.tileSize
        
        // game over node
        self.gameOverNode.size = frame.size
        self.gameOverNode.position = CGPoint(x: 0.0, y: 0.0)
        self.gameOverNode.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.gameOverNode.alpha = 0.8
        self.gameOverNode.zPosition = 10
    }
    
    func newGame()
    {
        for player in self.players {
            player.removeTiles()
            player.removeFromParent()
        }
        
        self.players.removeAll()
        
        gameOverNode.removeFromParent()
        
        for collectable in self.collectables {
            collectable.removeFromParent()
        }
        self.collectables.removeAll()
    }
    
    func pause()
    {
        if(self.running) {
            self.running = false
            self.delegate?.gameBoardPaused()
        }
    }
    
    func resume()
    {
        self.running = true
    }
    
    func addPlayer() -> Player? {
        if(self.running) {
            return nil
        }
        
        let color : SKColor
        if(players.count == 0) {
            color = GameScene.playerColors.player1
        } else if(players.count == 1) {
            color = GameScene.playerColors.player2
        } else if(players.count == 2) {
            color = GameScene.playerColors.player3
        } else {
            color = GameScene.playerColors.player4
        }
        
        let player = Player(x:  3, y: (self.players.count + 1) * 5, color: color, gameBoard: self)
        
        self.players.append(player)
        
        return player
    }
    
    func startGame()
    {
        self.spawnItem()

        running = true
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
        self.collectables.append(collectable)
        self.addChild(collectable)
    }
    
    func gameOver()
    {        
        running = false
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
    
    func numberOfAlivePlayers() -> Int
    {
        var n = 0
        for player in self.players {
            if(player.isAlive) {
                n++
            }
        }
        
        return n
    }
    
    func winningPlayer() -> Player?
    {
        for player in self.players {
            if(player.isAlive) {
                return player
            }
        }
        
        return nil
    }
    
    func updateStep(currentTime: CFTimeInterval)
    {
        if(!running) {
            return;
        }
        
        let grow = growTimer >= GameBoard.growingTime
        if(grow) {
            growTimer = 0
        }
        
        for(var i = 0; i < players.count; i++) {
            let player = players[i]
            if(player.isAlive) {
                if(player.step()) {
                    player.gameOver()
                }
                
                if(grow) {
                    player.grow(1)
                }
            }
        }
        
        growTimer++
    }
}