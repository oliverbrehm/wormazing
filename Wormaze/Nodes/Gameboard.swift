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
    static let spawningTime = 20//50 // steps
    
    var gameScene: GameScene?
    
    var delegate : GameBoardDelegate?
    
    var players: [Player] = []
    
    var spawnTimer = GameBoard.spawningTime - 15 // steps, initial value so first item will take less time to spawn
    var running = false
    
    var collectables: [Collectable] = []
    
    var tilesX: Int = 0
    var tilesY: Int = 0
    
    static let stepTime: CFTimeInterval = 0.13
    var lastStepTime: CFTimeInterval = 0;
    
    let gameOverNode = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 0.0 ,height: 0.0))
        
    required init?(coder aDecoder: NSCoder) {
        self.gameScene = GameScene()
        super.init(coder: aDecoder)
    }
    
    init() {
        self.tilesX = 0
        self.tilesY = 0
        super.init(texture: nil, color: GameView.gameColors.background, size: CGSizeZero)
    }
    
    func initialize(gameScene: GameScene, size: CGSize)
    {
        //self.shader = SKShader(fileNamed: "gameSceneFrame")
        
        self.gameScene = gameScene

        self.zPosition = GameScene.zPositions.Background
        self.size = size
        GameBoard.tileSize = Tile.texture.size().width
        
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        
        self.tilesX = Int(self.size.width / GameBoard.tileSize)
        self.tilesY = Int(self.size.height / GameBoard.tileSize)

        self.size.width = CGFloat(self.tilesX) * GameBoard.tileSize
        self.size.height = CGFloat(self.tilesY) * GameBoard.tileSize
        
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
            collectable.particles.removeFromParent()
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
        
        let id = self.players.count
        
        let color = GameScene.playerColors.colorForPlayer(id)!
        
        let player = Player(id: id, x:  3, y: (self.players.count + 1) * 5, color: color, gameBoard: self)
        player.initialize()
        
        self.players.append(player)
        
        return player
    }
    
    func startGame()
    {
        running = true
    }
    
    func addPlayerItemsNode(playerId: Int, node: SKSpriteNode)
    {
        node.zPosition = GameScene.zPositions.Menu
        self.addChild(node)
        
        switch(playerId) {
            case 0:
                node.position = CGPoint(x: 0.0, y: -35.0)
            case 1:
                node.position = CGPoint(x: self.size.width - node.size.width, y: -35.0)
            case 2:
                node.position = CGPoint(x: 0.0, y: self.size.height)
            case 3:
                node.position = CGPoint(x: self.size.width - node.size.width, y: self.size.height)
            default:
                node.position = CGPoint(x: 0.0, y: -35.0)
        }
    }
    
    func spawnItem()
    {
        var x, y : Int
        let maxTries = self.tilesX * self.tilesY
        var tries = 0
        
        repeat {
            x = Int(arc4random_uniform(UInt32(self.tilesX)))
            y = Int(arc4random_uniform(UInt32(self.tilesY)))
            tries++
        } while(self.pointOccupied(x, y: y) && tries < maxTries)
        
        if(tries == maxTries) {
            return
        }
        
        ((self.scene as! GameScene).view as! GameView).collectableManager.generate(self)
        if let collectable = ((self.scene as! GameScene).view as! GameView).collectableManager.getItem() {
            self.collectables.append(collectable)
            collectable.attatchToGameboard(x, y: y)
            self.updateLighting()
        }
    }
    
    func numOccupiedTilesAroundPoint(x: Int, y: Int) -> Int
    {
        var n = 0
        
        for player in self.players {
            for tile in player.tiles.tiles {
                if(tile == nil) {
                    continue
                }
                
                if(Float.abs(Float(tile!.x - x)) < 3 && Float.abs(Float(tile!.y - y)) < 3) {
                    n++
                }
            }
        }
        
        return n
    }
    
    func gameOver()
    {
        GameView.instance?.serializeUserData()
        
        for player in self.players {
            player.tiles.playerSparks?.removeFromParent()
        }

        running = false
    }
    
    func hitItem(x: Int, y: Int) -> Collectable? {
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
            return toRemove
        }
        
        return nil
    }
    
    func pointOccupied(x: Int, y: Int) -> Bool
    {
        for player in self.players {
            if(player.occupiesPoint(x, y: y)) {
                return true
            }
        }
        
        for collectable in self.collectables {
            if(collectable.x == x && collectable.y == y) {
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
    
    func update(currentTime: CFTimeInterval)
    {
        if(!running) {
            return;
        }
        
        for(var i = 0; i < players.count; i++) {
            let player = players[i]
            if(player.isAlive) {
                player.update(currentTime)
            }
        }
        
        if(currentTime > lastStepTime + GameBoard.stepTime) {
            lastStepTime = currentTime
            return self.step()
        }
    }
    
    func step()
    {
        self.updateLighting()
        
        // spawn item
        if(spawnTimer >= GameBoard.spawningTime) {
            spawnTimer = 0
            self.spawnItem()
        }
        
        spawnTimer++
    }
    
    func updateLighting()
    {
        for collectable in self.collectables {
            let d = self.distanceToPlayers(collectable.x, y: collectable.y)
            collectable.alpha = max(0.5, 1.0 - CGFloat(d) / 40.0)
        }
    }
    
    func distanceToPlayers(x: Int, y: Int) -> Int
    {
        var distance = Int.max
        
        for player in self.players {
            let d = player.distanceToPoint(x, y: y)
            if(d < distance) {
                distance = d
            }
        }
        
        return distance
    }
}