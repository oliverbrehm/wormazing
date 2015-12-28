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
    
    static let texture = SKTexture(imageNamed: "playerTile")
    static let headTexture = SKTexture(imageNamed: "playerHead")
    static let tailTexture = SKTexture(imageNamed: "playerTail")
    
    init(x: Int, y: Int, color: SKColor, predecessor: Tile?, playerDirection: PlayerDirection) {
        self.x = x;
        self.y = y;
        self.predecessor = predecessor
        
        super.init(texture: Tile.headTexture, color: color, size: CGSize(width: GameBoard.tileSize, height: GameBoard.tileSize))
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = CGPoint(x: (CGFloat(x) + 0.5) * GameBoard.tileSize, y: (CGFloat(y) + 0.5) * GameBoard.tileSize);
        self.zPosition = GameScene.zPositions.Player
        self.colorBlendFactor = 1.0
        
        switch(playerDirection) { // native sprite rotation pointing up
        case .down: self.rotateRight(); self.rotateRight()
        case .right: self.rotateRight()
        case .left: self.rotateLeft()
        default: break
        }
    }
    
    func makeBody() {
        self.texture = Tile.texture
    }
    
    func makeTail() {
        self.texture = Tile.tailTexture
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.x = 0
        self.y = 0
        self.predecessor = Tile(coder: aDecoder)!
        super.init(texture: nil, color: NSColor.blackColor(), size: CGSizeZero)
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
    var tiles: [Tile] = []
    var current = 0
    var increase: Int = 0
    
    func addTile(x: Int, y: Int, color: SKColor, playerDirection: PlayerDirection) -> Tile {
        self.head()?.makeBody()
        
        let tile = Tile(x: x, y: y, color: color, predecessor: self.head(), playerDirection: playerDirection)
        if(tiles.isEmpty) {
            tiles.append(tile)
            return tile
        }
        
        if(increase > 0) {
            tiles.insert(tile, atIndex: current)
            increase--
        } else {
            tiles[current].removeFromParent()
            tiles[current] = tile;
        }
        current = (current + 1) % tiles.count
        
        if(self.tiles.count > 1) {
            self.tail()?.makeTail()
        }
        
        return tile
    }
    
    func increaseCapacity(size: Int) {
        increase += size
    }
    
    func head() -> Tile? {
        if(self.tiles.count < 1) {
            return nil
        }
        
        var index = current - 1;
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
}