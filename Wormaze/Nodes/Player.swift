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
    var multiplayerExtralives = 1
    let itemsView: SKSpriteNode
    static let invincibilityTexture = SKTexture(imageNamed: "invincible")
    static let lifeTexture = SKTexture(imageNamed: "life")
    
    static let growingTime = 10 // steps
    static let invinibilityDuration = 25 // steps
    
    var countdown : UseLiftCountdwonNode?
    
    let id: Int

    var lastStepTime: CFTimeInterval = 0;

    var currentSpeed = 7.0
    static let speedDif = 2.0
    
    required init?(coder aDecoder: NSCoder) {
        self.id = 0
        tiles = PlayerTiles()
        color = SKColor.blackColor()
        self.itemsView = SKSpriteNode(coder: aDecoder)!
        self.gameBoard = GameBoard(coder: aDecoder)!
        super.init(coder: aDecoder)
    }
    
    init(id: Int, x: Int, y: Int, color: SKColor, gameBoard: GameBoard) {
        self.id = id
        self.gameBoard = gameBoard
        self.tiles = PlayerTiles()
        self.color = color
        //let alphaColor = SKColor(red: color.redComponent, green: color.greenComponent, blue: color.blueComponent, alpha: 0.5)
        self.itemsView = SKSpriteNode(color: color.colorWithAlphaComponent(0.5), size: CGSize(width: 300.0, height: 35.0))
        super.init()
        
        self.gameBoard.addChild(self.tiles.addTile(x, y: y, color: self.color, playerDirection: self.nextDirection))
    }
    
    func extralives() -> Int{
        if(self.gameBoard.gameScene!.gameMode == GameMode.singleplayer) {
            return GameView.instance!.extralives
        }
        
        return multiplayerExtralives
    }
    
    func update(currentTime: CFTimeInterval)
    {
        let stepTime = 1.0 / currentSpeed
        if(currentTime > lastStepTime + stepTime) {
            lastStepTime = currentTime
            self.step()
        }
    }
    
    func initialize()
    {
        if(GameView.instance!.gameScene!.gameMode == .multiplayer) {
            self.gameBoard.addPlayerItemsNode(self.id, node: self.itemsView)
            self.updateItemsView()
            self.itemsView.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        }
    }
    
    func incrementSpeed()
    {
        self.currentSpeed += Player.speedDif
    }
    
    func addInvincibility()
    {
        if(self.gameBoard.gameScene!.gameMode == GameMode.multiplayer) {
            self.invinibilityCount++
            self.updateItemsView()
        }
    }
    
    func useInvincibility()
    {
        if(self.gameBoard.gameScene!.gameMode == GameMode.singleplayer) {
            return
        }
        if(!self.gameBoard.running || self.invincible || self.invinibilityCount < 1) {
            return
        }
        
        self.invinibilityCount--
        self.updateItemsView()
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
        self.gameBoard.running = false

        if(self.gameBoard.gameScene!.gameMode == GameMode.multiplayer) {
            self.multiplayerExtralives--
            self.updateItemsView()
            self.extralifeUsed()
        } else {
            countdown = UseLiftCountdwonNode()
            countdown!.position = CGPoint(x: self.gameBoard.size.width / 2.0, y: self.gameBoard.size.height / 2.0)
            self.gameBoard.addChild(countdown!)
            countdown!.initialize()
            countdown!.execute(5) { () -> Void in
                self.gameOver()
                self.countdown!.removeFromParent()
                self.countdown = nil
                self.gameBoard.resume()
            }
        }
    }
    
    func extralifeUsed()
    {
        self.gameBoard.resume()
        for player in self.gameBoard.players {
            if let head = player.tiles.head() {
                // TODO only 1st player tiles get removed
                player.removeTilesAroundPoint(head.x, y: head.y)
            }
        }
        
        self.startInvincibility()
    }
    
    func updateItemsView()
    {
        self.itemsView.removeAllChildren()
        var x: CGFloat
        
        if(self.invinibilityCount >= 1) {
            x = 0.0
            for _ in 0...self.invinibilityCount - 1 {
                let inv = SKSpriteNode(texture: Player.invincibilityTexture)
                inv.zPosition = GameScene.zPositions.Menu
                inv.position = CGPoint(x: x, y: 0.0)
                inv.anchorPoint = CGPoint(x: 0.0, y: 0.0)
                self.itemsView.addChild(inv)
                x += 20.0
            }
        }
        
        if(self.multiplayerExtralives >= 1) {
            x = 0.0
            for _ in 0...self.multiplayerExtralives - 1 {
                let life = SKSpriteNode(texture: Player.lifeTexture)
                life.zPosition = GameScene.zPositions.Menu
                life.position = CGPoint(x: x, y: 20.0)
                life.anchorPoint = CGPoint(x: 0.0, y: 0.0)
                self.itemsView.addChild(life)
                x += 20.0
            }
        }
    }
    
    func addLive()
    {
        if(self.gameBoard.gameScene!.gameMode == GameMode.singleplayer) {
            if let v = GameView.instance {
                v.extralives++
                v.serializeUserData()
                self.gameBoard.consumablesNode.update()
            }
        } else {
            self.multiplayerExtralives++
            self.updateItemsView()
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
    
    func step()
    {
        if let board = self.gameBoard as? SingleplayerGame {
            board.updateScore()
        }
    
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
                } else if(self.extralives() > 0) {
                    self.useExtralive()
                    doStep = false
                } else {
                    gameOver()
                    return
                }
            }
            
            self.didNavigate = false
            
            if(doStep) {
                self.moveTo(destX, y: destY)
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
    }
    
    func navigate(playerDirection : PlayerDirection)
    {
        if(self.countdown != nil && self.countdown!.delayDone()) {
            GameView.instance!.extralives--
            GameView.instance!.serializeUserData()
            self.gameBoard.consumablesNode.update()
            self.extralifeUsed()
            self.countdown?.removeFromParent()
            self.countdown = nil
            return
        }
        
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