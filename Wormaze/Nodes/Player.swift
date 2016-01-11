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
    var isAlive = true
    var growTimer = 0 // steps
    var invincible = false
    var invincibilityTimer = 0 // steps
    
    var invinibilityCount = 3
    var extralives = 1
    let invincibilityView = SKNode()
    let extralivesView = SKNode()
    
    static let growingTime = 10 // steps
    static let invinibilityDuration = 25 // steps

    var lastStepTime: CFTimeInterval = 0;

    var currentSpeed = 7.0
    static let speedDif = 2.0
    
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
    
    func update(currentTime: CFTimeInterval) -> Bool
    {
        let stepTime = 1.0 / currentSpeed
        if(currentTime > lastStepTime + stepTime) {
            lastStepTime = currentTime
            return self.step()
        }
        
        return false
    }
    
    func initialize()
    {
        self.invincibilityView.zPosition = GameScene.zPositions.Menu
        self.invincibilityView.position = CGPoint(x: 10.0, y: -10.0)
        self.gameBoard.addChild(self.invincibilityView)
        self.updateInvincibilityView()
        
        self.extralivesView.zPosition = GameScene.zPositions.Menu
        self.extralivesView.position = CGPoint(x: self.gameBoard.size.width - 10.0, y: -10.0)
        self.gameBoard.addChild(self.extralivesView)
        self.updateExtralivesView()
    }
    
    func incrementSpeed()
    {
        self.currentSpeed += Player.speedDif
    }
    
    func addInvincibility()
    {
        self.invinibilityCount++
        self.updateInvincibilityView()
    }
    
    func useInvincibility()
    {
        if(self.invincible || self.invinibilityCount < 1) {
            return
        }
        
        self.invinibilityCount--
        self.updateInvincibilityView()
        self.startInvincibility()
    }
    
    func startInvincibility()
    {
        self.invincible = true
        self.tiles.toggleInvincibility(true)
    }
    
    func stopInvincibility()
    {
        self.invincible = false
        self.tiles.toggleInvincibility(false)
    }
    
    func removeTilesAroundPoint(x: Int, y: Int)
    {
        var toDelete: [Int] = []
        
        for(var i = 0; i < tiles.tiles.count; i++) {
            let tile = tiles.tiles[i]
            if(tile == nil) {
                continue
            }
            
            let dx = CGFloat.abs(CGFloat(x - tile!.x))
            let dy = CGFloat.abs(CGFloat(y - tile!.y))
            
            if(dx <= 2 && dy <= 2 && tile !== self.tiles.head()) {
                toDelete.append(i)
            }
        }
        
        for index in toDelete {
            self.tiles.removeIndex(index)
        }
    }
    
    func useExtralive()
    {
        self.extralives--
        self.updateExtralivesView()
        
        if let head = self.tiles.head() {
            self.removeTilesAroundPoint(head.x, y: head.y)
        }
    }
    
    func updateInvincibilityView()
    {
        self.invincibilityView.removeAllChildren()
        
        if(self.invinibilityCount < 1) {
            return
        }
        
        var x: CGFloat = 0.0
        for _ in 0...self.invinibilityCount - 1 {
            let inv = SKSpriteNode(color: SKColor.blueColor(), size: CGSize(width: 10.0, height: 10.0))
            inv.zPosition = GameScene.zPositions.Menu
            inv.position = CGPoint(x: x, y: 0.0)
            self.invincibilityView.addChild(inv)
            x += 20.0
        }
    }
    
    func addLive()
    {
        self.extralives++
        self.updateExtralivesView()
    }
    
    func updateExtralivesView()
    {
        self.extralivesView.removeAllChildren()

        if(self.extralives < 1) {
            return
        }
    
        var x: CGFloat = 0.0
        for _ in 0...self.extralives - 1 {
            let life = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 10.0, height: 10.0))
            life.zPosition = GameScene.zPositions.Menu
            life.position = CGPoint(x: x, y: 0.0)
            self.extralivesView.addChild(life)
            x -= 20.0
        }
    }
    
    func decrementSpeed()
    {
        self.currentSpeed -= Player.speedDif
        if(self.currentSpeed <= 2.0) {
            self.currentSpeed = 2.0
        }
    }
    
    func moveTo(x: Int, y: Int) {
        self.gameBoard.addChild(self.tiles.addTile(x, y: y, color: self.color, playerDirection: self.nextDirection))
    }
    
    func gameOver()
    {
        self.isAlive = false
        self.tiles.die()
    }
    
    func grow(size: Int)
    {
        self.tiles.increaseCapacity(size)
    }
    
    func removeTiles()
    {
        for tile in self.tiles.tiles
        {
            tile?.removeFromParent()
        }
    }
    
    func occupiesPoint(x: Int, y: Int) -> Bool
    {
        for tile in self.tiles.tiles {
            if(tile == nil) {
                continue
            }
            
            if(tile!.x == x && tile!.y == y) {
                return true
            }
        }
        
        return false
    }
    
    func checkCollision(x: Int, y: Int, invincible: Bool) -> Bool {
        
        if(x < 0 || y < 0
            || x >= gameBoard.tilesX || y >= gameBoard.tilesY) {
            return true;
        }
        
        if(invincible) {
            return false
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
    
    func length() -> Int
    {
        return self.tiles.tiles.count
    }
    
    func pause()
    {
        self.gameBoard.pause()
    }
    
    func step() -> Bool
    {
        if let head = self.tiles.head() {
            var destX = head.x;
            var destY = head.y;
            
            var doStep = true
            
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
            
            if(checkCollision(destX, y: destY, invincible: self.invincible)) {
                if(self.invincible) {
                    doStep = false
                } else if(extralives > 0) {
                    self.useExtralive()
                    self.startInvincibility()
                    doStep = false
                } else {
                    return true // game over
                }
            }
            
            if(doStep) {
                self.moveTo(destX, y: destY)
                self.didNavigate = false
            }
            
            if let item = self.gameBoard.hitItem(destX, y: destY) {
                item.hit(self)
            }
            
            if(growTimer >= Player.growingTime) {
                growTimer = 0
                self.grow(1)
            }
            growTimer++
            
            if(invincibilityTimer >= Player.invinibilityDuration) {
                invincibilityTimer = 0
                self.stopInvincibility()
            }
            
            if(invincible) {
                invincibilityTimer++
            }
        }
        
        return false
    }
    
    func navigate(playerDirection : PlayerDirection)
    {
        if(didNavigate || !self.gameBoard.running) {
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