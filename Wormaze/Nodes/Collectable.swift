//
//  Collectable.swift
//  Wormazing
//
//  Created by Oliver Brehm on 26.12.15.
//  Copyright © 2015 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class Collectable: SKSpriteNode {
    var x, y: Int
    
    var lastTime: CFTimeInterval = -1.0
    
    static let texture = SKTexture(imageNamed: "collectable")
    
    init(x: Int, y: Int)
    {
        self.x = x
        self.y = y
        
        super.init(texture: Collectable.texture, color: SKColor.blueColor(), size: CGSize(width: GameBoard.tileSize, height: GameBoard.tileSize))
        
        self.zPosition = GameScene.zPositions.Player
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
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
}