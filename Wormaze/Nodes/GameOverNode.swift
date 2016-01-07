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
        super.init(size: CGSize(width: 400.0, height: 300.0), color: SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3))
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func initialize()
    {
        self.zPosition = GameScene.zPositions.Background
        let localGameButton = MenuButton(size: CGSize(width: 200, height: 100), label: "Play again", name: "playAgain");
        localGameButton.position = CGPoint(x: 0.0, y: 120.0)
        self.addItem(localGameButton)
        localGameButton.initialize()
        
        let exitGameButton = MenuButton(size: CGSize(width: 200, height: 100), label: "To Menu", name: "toMenu");
        exitGameButton.position = CGPoint(x: 0.0, y: -0.0)
        self.addItem(exitGameButton)
        exitGameButton.initialize()
    }
}