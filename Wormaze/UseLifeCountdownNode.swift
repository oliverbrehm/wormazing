//
//  File.swift
//  Wormazing
//
//  Created by Oliver Brehm on 21.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class UseLiftCountdwonNode: SKCropNode {
    let countdownLabel = SKLabelNode(fontNamed: "Chalkduster")
    var counter = 0
    var counterMax = 0
    
    func initialize() {
        let node = SKSpriteNode()
        self.zPosition = GameScene.zPositions.Menu
        node.size = CGSize(width: 250.0, height: 250.0)
        node.color = SKColor.redColor()
        node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        countdownLabel.text = ""
        countdownLabel.fontColor = SKColor.greenColor()
        countdownLabel.fontSize = 40
        node.addChild(countdownLabel)
        
        let infoLabel1 = SKLabelNode(fontNamed: "Chalkduster")
        infoLabel1.fontColor = SKColor.whiteColor()
        infoLabel1.fontSize = 20
        infoLabel1.text = "Use extralife?"
        infoLabel1.position = CGPoint(x: 0.0, y: 75.0)
        self.addChild(infoLabel1)
        
        let infoLabel2 = SKLabelNode(fontNamed: "Chalkduster")
        infoLabel2.fontColor = SKColor.blackColor()
        infoLabel2.fontSize = 20
        infoLabel2.text = "Press any direction"
        infoLabel2.position = CGPoint(x: 0.0, y: -75.0)
        node.addChild(infoLabel2)
        
        let mask = SKShapeNode()
        mask.path = CGPathCreateWithRoundedRect(node.frame, 10.0, 10.0, nil)
        mask.fillColor = SKColor.whiteColor()
        self.maskNode = mask
        self.addChild(node)
    }
    
    func execute(secs: Int, completion: () -> Void) {
        counter = secs
        counterMax = secs
        
        self.countdownLabel.text = "\(self.counter)"

        let waitAndDecrement = SKAction.sequence([SKAction.waitForDuration(1), SKAction.runBlock({
            self.counter--
            self.countdownLabel.text = "\(self.counter)"
        })])
        
        self.runAction(SKAction.repeatAction(waitAndDecrement, count: secs)) { () -> Void in
            completion()
        }
    }
    
    func delayDone() -> Bool{
        if(counter < counterMax) {
            return true
        }
        
        return false
    }
}