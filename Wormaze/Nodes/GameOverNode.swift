//
//  GameOverNode.swift
//  Wormazing
//
//  Created by Oliver Brehm on 28.12.15.
//  Copyright © 2015 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverNode : DialogNode
{
    init()
    {
        super.init(size: CGSize(width: 400.0, height: 300.0), color: SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5), name: "GameOverNode")
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func initialize(message: String, color: SKColor)
    {
        let localGameButton = MenuButton(label: "Play again", name: "playAgain");
        localGameButton.position = CGPoint(x: 0.0, y: 00.0)
        localGameButton.initialize()
        self.addItem(localGameButton)
        
        let exitGameButton = MenuButton(label: "To Menu", name: "toMenu");
        exitGameButton.position = CGPoint(x: 0.0, y: -120.0)
        exitGameButton.initialize()
        self.addItem(exitGameButton)
        
        let messageNode : SKLabelNode = SKLabelNode(fontNamed: "Chalkduster")
        messageNode.fontSize = 32.0
        messageNode.fontColor = color
        messageNode.position = CGPoint(x: 0.0, y: 120.0)
        messageNode.text = message
        self.addChild(messageNode)
    }
}