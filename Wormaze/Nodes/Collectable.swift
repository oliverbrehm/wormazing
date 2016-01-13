//
//  Collectable.swift
//  Wormazing
//
//  Created by Oliver Brehm on 26.12.15.
//  Copyright © 2015 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class ItemScores
{
    static let grow: Float = 500.0
    static let speedInc: Float = 2000.0
    static let speedDec: Float = 100.0
    static let invincible: Float = 50.0
    static let extralife: Float = 500.0
    static let coin: Float = 200.0
}

class Collectable: SKSpriteNode {
    var x, y: Int
    
    var lastTime: CFTimeInterval = -1.0
    var gameboard: GameBoard?
    
    init(gameboard: GameBoard)
    {
        self.gameboard = gameboard
    
        self.x = 0
        self.y = 0
        
        super.init(texture: nil, color: SKColor.blackColor(), size: CGSize(width: GameBoard.tileSize, height: GameBoard.tileSize))
        
        self.zPosition = GameScene.zPositions.Player
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

    }
    
    func attatchToGameboard(x: Int, y: Int, gameBoard: GameBoard)
    {
        self.x = x
        self.y = y
        
        gameBoard.addChild(self)
        
        self.position = CGPoint(x: (CGFloat(x) + 0.5) * GameBoard.tileSize, y: (CGFloat(y) + 0.5) * GameBoard.tileSize);
        self.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(2 * M_PI), duration: 4.0)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.x = 0
        self.y = 0
        super.init(coder: aDecoder)
    }
    
    func update(time: CFTimeInterval) {
        if(lastTime > 0.0) {
            let dt = time - lastTime
            let rotation = CGFloat(dt * 0.3 * M_PI)
            self.zRotation += rotation
        }
        
        lastTime = time
    }
    
    func score() -> Float {
        return 0.0 // implemented in subclass
    }
    
    func hit(player: Player) {
        if let board = gameboard as? SingleplayerGame {
        let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
            scoreLabel.text = "\(Int(self.score()))"
            scoreLabel.fontSize = 16.0
            scoreLabel.position = CGPoint(x: self.position.x, y: self.position.y + 30.0)
            scoreLabel.zPosition = GameScene.zPositions.GameboardOverlay
            
            board.addChild(scoreLabel)
            
            let waitAction = SKAction.waitForDuration(0.5)
            let moveAction = SKAction.moveTo(board.scoreLabel.position, duration: 0.3)
            moveAction.timingMode = SKActionTimingMode.EaseInEaseOut
            
            scoreLabel.runAction(SKAction.sequence([waitAction, moveAction]), completion: {
                board.addScore(self.score())
                scoreLabel.removeFromParent()
            })
        }
    

    }
}