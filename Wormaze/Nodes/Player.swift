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
    
    init(x: Int, y: Int, color: SKColor) {
        self.x = x;
        self.y = y;
        
        super.init(texture: nil, color: color, size: CGSize(width: GameBoard.tileSize, height: GameBoard.tileSize))

        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.position = CGPoint(x: CGFloat(x) * GameBoard.tileSize, y: CGFloat(y) * GameBoard.tileSize);
    }

    required init?(coder aDecoder: NSCoder) {
        self.x = 0
        self.y = 0
        super.init(texture: nil, color: NSColor.blackColor(), size: CGSizeZero)
    }
}

class Tiles
{
    var tiles: [PlayerTile] = [PlayerTile(x: 0,y: 0, color: SKColor.blackColor())]
    var current = 0
    var increase: Int = 0
    
    func addTile(tile: PlayerTile) {

        if(increase > 0) {
            tiles.insert(tile, atIndex: current)
            increase--
        } else {
            tiles[current].removeFromParent()
            tiles[current] = tile;
        }
        current = (current + 1) % tiles.count
    }
    
    func increaseCapacity(size: Int) {
        increase += size
    }
    
    func head() -> PlayerTile {
        var index = current - 1;
        if(index < 0) {
            index = tiles.count - 1;
        }
        return tiles[index]
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
        gameBoard = GameBoard(tilesX: 50, tilesY: 50)
        tiles = Tiles()
        color = SKColor.blackColor()
        super.init(coder: aDecoder)
    }
    
    init(x: Int, y: Int, color: SKColor, gameBoard: GameBoard) {
        self.gameBoard = gameBoard
        self.tiles = Tiles()
        self.color = color
        super.init()
        
        let tile = PlayerTile(x: x, y: y, color: self.color)
        self.tiles.addTile(tile)
        self.gameBoard.addChild(tile)
    }
    
    func moveTo(x: Int, y: Int) {
        print("moveTo \(x), \(y)")
        let newTile = PlayerTile(x: x, y: y, color: self.color)
        self.tiles.addTile(newTile)
        self.gameBoard.addChild(newTile)
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
        let head = self.tiles.head()
        
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
        
        return false
    }
    
    func navigate(playerDirection : PlayerDirection)
    {
        if(didNavigate) {
            return;
        }
        
        // impossible cases
        if(nextDirection == PlayerDirection.up && playerDirection == PlayerDirection.down
            || nextDirection == PlayerDirection.down && playerDirection == PlayerDirection.up
            || nextDirection == PlayerDirection.left && playerDirection == PlayerDirection.right
            || nextDirection == PlayerDirection.right && playerDirection == PlayerDirection.left) {
                return;
        } else {
            self.nextDirection = playerDirection
            didNavigate = true
        }
    }
}