
//
//  PlayerTiles.swift
//  Wormazing
//
//  Created by Oliver Brehm on 28.12.15.
//  Copyright © 2015 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class Tile : SKSpriteNode {
    var x, y : Int
    let predecessor : Tile?
    var dead = false
    
    static let texture = SKTexture(imageNamed: "playerTile")
    static let headTexture = SKTexture(imageNamed: "playerHead")
    static let tailTexture = SKTexture(imageNamed: "playerTail")
    
    init(x: Int, y: Int, color: SKColor, predecessor: Tile?, playerDirection: PlayerDirection, invincible: Bool, invincibilityNode: SKSpriteNode) {
        self.x = x;
        self.y = y;
        self.predecessor = predecessor
        
        super.init(texture: Tile.headTexture, color: color, size: CGSize(width: GameBoard.tileSize, height: GameBoard.tileSize))
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = CGPoint(x: (CGFloat(x) + 0.5) * GameBoard.tileSize, y: (CGFloat(y) + 0.5) * GameBoard.tileSize);
        self.zPosition = GameScene.zPositions.Player
        self.colorBlendFactor = 1.0
        
        if(invincible) {
            self.addChild(invincibilityNode)
        }

        switch(playerDirection) { // native sprite rotation pointing up
        case .down: self.rotateRight(); self.rotateRight()
        case .right: self.rotateRight()
        case .left: self.rotateLeft()
        default: break
        }
    }
    
    func makeBody() {
        self.removeAllChildren()
        self.texture = Tile.texture
    }
    
    func makeTail() {
        self.removeAllChildren()
        self.texture = Tile.tailTexture
    }
    
    func die(delay: NSTimeInterval, delayDelta: NSTimeInterval, tiles: PlayerTiles, index: Int) {
        let delayAction = SKAction.waitForDuration(delay)
        let colorizeAction = SKAction.colorizeWithColor(SKColor(white: 0.3, alpha: 1.0), colorBlendFactor: 1.0, duration: 0.5)
        let deletionDelayAction = SKAction.waitForDuration(delayDelta * Double(tiles.tiles.count))
        
        self.runAction(SKAction.sequence([delayAction, colorizeAction, deletionDelayAction]), completion: {
            tiles.removeIndex(index)
        })
        
        self.dead = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.x = 0
        self.y = 0
        self.predecessor = Tile(coder: aDecoder)!
        super.init(texture: nil, color: SKColor.blackColor(), size: CGSizeZero)
    }
    
    func rotateLeft() {
        self.zRotation += CGFloat(M_PI / 2.0)
    }
    
    func rotateRight() {
        self.zRotation -= CGFloat(M_PI / 2.0)
    }
    
    func halfRotateLeft() {
        self.zRotation += CGFloat(M_PI / 4.0)
    }
    
    func halfRotateRight() {
        self.zRotation -= CGFloat(M_PI / 4.0)
    }
}

class PlayerTiles
{
    var tiles: [Tile?] = []
    var current = 0
    var increase: Int = 0
    
    var invincible = false
    
    let invincibilityNode = SKSpriteNode(imageNamed: "extrainvincible")
    
    var playerSparks : SKEmitterNode?
    
    var player: Player?
    
    init() {
        self.invincibilityNode.alpha = 0.5
        self.invincibilityNode.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(2.0 * M_PI), duration: 0.8)))
        
        self.playerSparks = SKEmitterNode(fileNamed: "playerSpark")
        self.playerSparks!.particleBirthRate = 0
        self.playerSparks!.targetNode = GameView.instance!.gameScene!.gameBoard
    }
    
    func addTile(x: Int, y: Int, color: SKColor, playerDirection: PlayerDirection) -> Tile {
        self.head()?.makeBody()
        
        let tile = Tile(x: x, y: y, color: color, predecessor: self.head(), playerDirection: playerDirection, invincible: invincible, invincibilityNode: invincibilityNode)
        if(tiles.isEmpty) {
            tiles.append(tile)
            return tile
        }
        
        if(increase > 0) {
            tiles.insert(tile, atIndex: current)
            increase--
        } else {
            tiles[current]?.removeFromParent()
            tiles[current] = tile;
        }
        current = (current + 1) % tiles.count
        
        if(self.tiles.count > 1) {
            self.tail()?.makeTail()
        }
        
        if let h = self.head() {
            self.playerSparks?.removeFromParent()
            h.addChild(self.playerSparks!)
            self.playerSparks?.particleBirthRate = max(CGFloat(self.player!.numOccupiedTilesAroundHead() - 4) * 100.0, 0.0)
        }
        
        return tile
    }
    
    func toggleInvincibility(invincibility: Bool) {
        self.invincible = invincibility
        
        if let head = self.head() {
            if(invincible) {
                head.addChild(self.invincibilityNode)
            } else {
                head.removeAllChildren()
            }
        }
    }
    
    func removeIndex(index: Int) {
        let tile = self.tiles[index]

        let explosion = SKEmitterNode(fileNamed: "explosion")!
        
        if(GameView.instance!.gameScene == nil) {
            return
        }
        
        let gameboard = GameView.instance!.gameScene!.gameBoard
        explosion.position = tile!.position
        gameboard.addChild(explosion)
        
        
        explosion.runAction(SKAction.waitForDuration(0.5)) { () -> Void in
            explosion.particleBirthRate = 0
            explosion.runAction(SKAction.waitForDuration(5.0)) { () -> Void in
                explosion.removeFromParent()
            }
        }
        
        tile?.runAction(SKAction.fadeOutWithDuration(1.0), completion: { () -> Void in
            tile?.removeFromParent()
        })
        
        self.tiles[index] = nil
    }
    
    func increaseCapacity(size: Int) {
        increase += size
    }
    
    func head() -> Tile? {
        if(self.tiles.count < 1) {
            return nil
        }
        
        var index = current - 1;
        
        if(index >= tiles.count) {
            return nil
        }
        
        if(index < 0) {
            index = tiles.count - 1;
        }
        return tiles[index]
    }
    
    func tail() -> Tile? {
        if(self.tiles.count < 1) {
            return nil
        }
        
        return tiles[current]
    }
    
    func die()
    {
        self.playerSparks?.removeFromParent()
        
        if(self.tiles.count < 1) {
            return
        }
        
        let delayDelta = 0.07
        var delay = 0.0
        
        for(var i = current - 1;;) {
            if(i < 0) {
                i = self.tiles.count - 1
            }
            
            let tile = self.tiles[i]
            tile?.die(delay, delayDelta: delayDelta, tiles: self, index: i)
            delay += delayDelta
            
            i--
            if(i == current - 1) {
                break
            }
        }
    }
}