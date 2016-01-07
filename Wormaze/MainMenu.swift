//
//  MainMenu.swift
//  Wormazing
//
//  Created by Oliver Brehm on 28.12.15.
//  Copyright © 2015 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenu : DialogNode
{
    init()
    {
        super.init(size: CGSize(width: 400.0, height: 300.0), color: SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5))
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)        
    }
    
    func initialize()
    {
        let localGameButton = MenuButton(size: CGSize(width: 200, height: 100), label: "Start Game", name: "startGame");
        localGameButton.position = CGPoint(x: 0.0, y: 120.0)
        self.addItem(localGameButton)
        localGameButton.initialize()
        
        let exitGameButton = MenuButton(size: CGSize(width: 200, height: 100), label: "Exit", name: "exitGame");
        exitGameButton.position = CGPoint(x: 0.0, y: -0.0)
        self.addItem(exitGameButton)
        exitGameButton.initialize()
        
        let testButton = MenuButton(size: CGSize(width: 200, height: 100), label: "Test", name: "test");
        testButton.position = CGPoint(x: 0.0, y: -120.0)
        self.addItem(testButton)
        testButton.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}