//
//  LivesNode.swift
//  Wormazing
//
//  Created by Oliver Brehm on 20.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class LivesNode: SKNode {
    var livesLabel: SKLabelNode?

    func initialize(coins: Int)
    {
        self.zPosition = GameScene.zPositions.Menu
    
        let lifeImage = SKSpriteNode(imageNamed: "extralife")
        lifeImage.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        self.addChild(lifeImage)
        
        livesLabel = SKLabelNode(fontNamed: "Chalkduster")
        livesLabel!.text = "x \(coins)"
        livesLabel!.position = CGPoint(x: lifeImage.size.width + 50.0, y: -lifeImage.size.height / 2.0 - livesLabel!.fontSize / 2.0)
        self.addChild(livesLabel!)
    }
    
    func update(coins: Int) {
        if let l = self.livesLabel {
            l.text = "x \(coins)"
        }
    }
    
    func setColor(color: SKColor) {
        self.livesLabel?.fontColor = color
    }
}