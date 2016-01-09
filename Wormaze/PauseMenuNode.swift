//
//  PauseMenuNode.swift
//  Wormazing
//
//  Created by Oliver Brehm on 08.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class PauseMenuNode: DialogNode {
    init()
    {
        super.init(size: CGSize(width: 400.0, height: 300.0), color: SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5), name: "PauseMenuNode")
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func initialize()
    {
        let continueButton = MenuButton(size: CGSize(width: 200, height: 100), label: "Resume", name: "continue");
        continueButton.position = CGPoint(x: 0.0, y: 00.0)
        self.addItem(continueButton)
        continueButton.initialize()
        
        let exitGameButton = MenuButton(size: CGSize(width: 200, height: 100), label: "Exit game", name: "toMenu");
        exitGameButton.position = CGPoint(x: 0.0, y: -120.0)
        self.addItem(exitGameButton)
        exitGameButton.initialize()
        
        let messageNode : SKLabelNode = SKLabelNode(fontNamed: "Chalkduster")
        messageNode.fontSize = 32.0
        messageNode.position = CGPoint(x: 0.0, y: 120.0)
        messageNode.text = "Game paused"
        self.addChild(messageNode)
    }
}