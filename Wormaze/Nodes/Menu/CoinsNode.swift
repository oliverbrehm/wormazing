//
//  CoinsNode.swift
//  Wormazing
//
//  Created by Oliver Brehm on 13.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class CoinsNode: SKNode {
    var coinLabel: SKLabelNode?

    func initialize(coins: Int)
    {
        self.zPosition = GameScene.zPositions.Menu
    
        let coinImage = SKSpriteNode(imageNamed: "coin")
        coinImage.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        self.addChild(coinImage)
        
        coinLabel = SKLabelNode(fontNamed: "Chalkduster")
        coinLabel!.text = "x \(coins)"
        coinLabel!.position = CGPoint(x: coinImage.size.width + 50.0, y: -coinImage.size.height / 2.0 - coinLabel!.fontSize / 2.0)
        self.addChild(coinLabel!)
    }
    
    func update(coins: Int) {
        if let l = self.coinLabel {
            l.text = "x \(coins)"
        }
    }
    
    func setColor(color: SKColor) {
        self.coinLabel?.fontColor = color
    }
}