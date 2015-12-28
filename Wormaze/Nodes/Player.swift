//
//  Player.swift
//  Wormaze
//
//  Created by Oliver Brehm on 25.12.15.
//  Copyright © 2015 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

enum PlayerDirection : Int
{
    case up, down, left, right
}

class Player: SKNode {
    var nextDirection = PlayerDirection.right
    var tiles: PlayerTiles
    let gameBoard: GameBoard
    let color: SKColor
    var didNavigate = false
    
    required init?(coder aDecoder: NSCoder) {
        gameBoard = GameBoard()
        tiles = PlayerTiles()
        color = SKColor.blackColor()
        super.init(coder: aDecoder)
    }
    
    init(x: Int, y: Int, color: SKColor, gameBoard: GameBoard) {
        self.gameBoard = gameBoard
        self.tiles = PlayerTiles()
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