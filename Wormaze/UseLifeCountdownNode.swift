//
//  File.swift
//  Wormazing
//
//  Created by Oliver Brehm on 21.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class UseLiftCountdwonNode: SKSpriteNode {
    let countdownLabel = SKLabelNode(fontNamed: "Chalkduster")
    var counter = 0
    var counterMax = 0
    
    func initialize() {
        self.zPosition = GameScene.zPositions.Menu
        self.size = CGSize(width: 250.0, height: 250.0)
        self.color = SKColor.redColor()
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        countdownLabel.text = ""
        countdownLabel.fontColor = SKColor.greenColor()
        countdownLabel.fontSize = 40
        self.addChild(countdownLabel)
        
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
        self.addChild(infoLabel2)
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