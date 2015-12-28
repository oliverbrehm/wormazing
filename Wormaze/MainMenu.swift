//
//  MainMenu.swift
//  Wormazing
//
//  Created by Oliver Brehm on 28.12.15.
//  Copyright © 2015 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

enum MainMenuOption
{
    case StartGame
}

protocol MainMenuDelegate
{
    func mainMenuDidSelectOption(option: MainMenuOption)
}

class MainMenu : DialogNode
{
    var delegate: MainMenuDelegate?
    
    init(delegate: MainMenuDelegate?)
    {
        self.delegate = delegate
        super.init(size: CGSize(width: 400.0, height: 300.0), color: SKColor(calibratedRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.5))
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
    
    convenience init()
    {
        self.init(delegate: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.delegate = nil
        super.init(coder: aDecoder)
    }
    
    func acceptItem()
    {
        if(self.selectedItem().name == "startGame") {
            self.delegate?.mainMenuDidSelectOption(.StartGame)
        } else if(self.selectedItem().name == "exitGame") {
            exit(EXIT_SUCCESS)
        }
    }
    
}