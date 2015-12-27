//
//  Player.swift
//  Wormaze
//
//  Created by Oliver Brehm on 25.12.15.
//  Copyright © 2015 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class PlayerTile : SKSpriteNode {
    var x, y : Int
    let predecessor : PlayerTile?
    
    static let texture = SKTexture(imageNamed: "playerTile")
    static let headTexture = SKTexture(imageNamed: "playerHead")
    static let tailTexture = SKTexture(imageNamed: "playerTail")
    
    init(x: Int, y: Int, color: SKColor, predecessor: PlayerTile?, playerDirection: PlayerDirection) {
        self.x = x;
        self.y = y;
        self.predecessor = predecessor
        
        super.init(texture: PlayerTile.headTexture, color: color, size: CGSize(width: GameBoard.tileSize, height: GameBoard.tileSize))

        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = CGPoint(x: (CGFloat(x) + 0.5) * GameBoard.tileSize, y: (CGFloat(y) + 0.5) * GameBoard.tileSize);
        self.colorBlendFactor = 1.0
        
        switch(playerDirection) { // native sprite rotation pointing up
        case .down: self.rotateRight(); self.rotateRight()
        case .right: self.rotateRight()
        case .left: self.rotateLeft()
        default: break
        }
    }
    
    func makeBody() {
        self.texture = PlayerTile.texture
    }
    
    func makeTail() {
        self.texture = PlayerTile.tailTexture
    }

    required init?(coder aDecoder: NSCoder) {
        self.x = 0
        self.y = 0
        self.predecessor = PlayerTile(coder: aDecoder)!
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

class Tiles
{
    var tiles: [PlayerTile] = []
    var current = 0
    var increase: Int = 0
    
    func addTile(x: Int, y: Int, color: SKColor, playerDirection: PlayerDirection) -> PlayerTile {
        self.head()?.makeBody()
        
        let tile = PlayerTile(x: x, y: y, color: color, predecessor: self.head(), playerDirection: playerDirection)
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
    
    func head() -> PlayerTile? {
        if(self.tiles.count < 1) {
            return nil
        }
        
        var index = current - 1;
        if(index < 0) {
            index = tiles.count - 1;
        }
        return tiles[index]
    }
    
    func tail() -> PlayerTile? {
        if(self.tiles.count < 1) {
            return nil
        }
        
        return tiles[current]
    }
}

enum PlayerDirection : Int
{
    case up, down, left, right
}

class Player: SKNode {
    var nextDirection = PlayerDirection.right
    var tiles: Tiles
    let gameBoard: GameBoard
    let color: SKColor
    var didNavigate = false
    
    required init?(coder aDecoder: NSCoder) {
        gameBoard = GameBoard()
        tiles = Tiles()
        color = SKColor.blackColor()
        super.init(coder: aDecoder)
    }
    
    init(x: Int, y: Int, color: SKColor, gameBoard: GameBoard) {
        self.gameBoard = gameBoard
        self.tiles = Tiles()
        self.color = color
        super.init()
        
        self.gameBoard.addChild(self.tiles.addTile(x, y: y, color: self.color, playerDirection: self.nextDirection))
    }
    
    func moveTo(x: Int, y: Int) {
        print("moveTo \(x), \(y)")
        self.gameBoard.addChild(self.tiles.addTile(x, y: y, color: self.color, playerDirection: self.nextDirection))
    }
    
    func grow(size: Int)
    {
        self.tiles.increaseCapacity(size)
    }
    
    func removeTiles()
    {
        for tile in self.tiles.tiles
        {
            tile.removeFromParent()
        }
    }
    
    func occupiesPoint(x: Int, y: Int) -> Bool
    {
        for tile in self.tiles.tiles {
            if(tile.x == x && tile.y == y) {
                return true
            }
        }
        
        return false
    }
    
    func checkCollision(x: Int, y: Int) -> Bool {
        
        if(x < 0 || y < 0
            || x >= gameBoard.tilesX || y >= gameBoard.tilesY) {
            return true;
        }
        
        for player in self.gameBoard.players
        {
            if(player.occupiesPoint(x, y: y))
            {
                return true
            }
        }
        
        return false;
    }
    
    func step() -> Bool
    {
        if let head = self.tiles.head() {
            var destX = head.x;
            var destY = head.y;
            
            switch(nextDirection) {
            case .up:
                destY += 1
            case .down:
                destY -= 1
            case .left:
                destX -= 1
            case.right:
                destX += 1
            }
            
            if(checkCollision(destX, y: destY)) {
                return true
            }
            
            self.moveTo(destX, y: destY)
            self.didNavigate = false
            
            if(self.gameBoard.hitItem(destX, y: destY)) {
                self.grow(5)
                self.gameBoard.spawnItem()
            }
        }
        
        return false
    }
    
    func navigate(playerDirection : PlayerDirection)
    {
        if(didNavigate) {
            return;
        }
        
        // impossible cases
        if(nextDirection == playerDirection
            || nextDirection == PlayerDirection.up && playerDirection == PlayerDirection.down
            || nextDirection == PlayerDirection.down && playerDirection == PlayerDirection.up
            || nextDirection == PlayerDirection.left && playerDirection == PlayerDirection.right
            || nextDirection == PlayerDirection.right && playerDirection == PlayerDirection.left) {
                return;
        } else {
            switch(self.nextDirection) {
            case .left:
                if(playerDirection == PlayerDirection.up) { self.tiles.head()?.halfRotateRight() }
                else { self.tiles.head()?.halfRotateLeft() }
                
            case .right:
                if(playerDirection == PlayerDirection.up) { self.tiles.head()?.halfRotateLeft() }
                else { self.tiles.head()?.halfRotateRight() }
                
            case .up:
                if(playerDirection == PlayerDirection.left) { self.tiles.head()?.halfRotateLeft() }
                else { self.tiles.head()?.halfRotateRight() }
                
            case .down:
                if(playerDirection == PlayerDirection.left) { self.tiles.head()?.halfRotateRight() }
                else { self.tiles.head()?.halfRotateLeft() }
            }
            
            self.nextDirection = playerDirection
            didNavigate = true
        }
    }
}