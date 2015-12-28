//
//  GameOverNode.swift
//  Wormazing
//
//  Created by Oliver Brehm on 28.12.15.
//  Copyright © 2015 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

protocol GameOverNodeDelegate
{
    func gameOverNodeDidContinue()
    func gameOverNodeDidCancel()
}

class GameOverNode : DialogNode
{
    let delegate: GameOverNodeDelegate?
    
    init(delegate: GameOverNodeDelegate?)
    {
        self.delegate = delegate
        super.init()
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    convenience override init()
    {
        self.init(delegate: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        self.delegate = nil
        super.init(coder: aDecoder)
    }

    func initialize()
    {
        let localGameButton = MenuButton(size: CGSize(width: 200, height: 100), label: "Play again", name: "playAgain");
        localGameButton.position = CGPoint(x: 0.0, y: 120.0)
        self.addItem(localGameButton)
        localGameButton.initialize()
        
        let exitGameButton = MenuButton(size: CGSize(width: 200, height: 100), label: "To Menu", name: "toMenu");
        exitGameButton.position = CGPoint(x: 0.0, y: -0.0)
        self.addItem(exitGameButton)
        exitGameButton.initialize()
    }
    
    func acceptItem() {
        if(self.selectedItem().name == "playAgain") {
            self.delegate?.gameOverNodeDidContinue()
        } else if(self.selectedItem().name == "toMenu") {
            self.delegate?.gameOverNodeDidCancel()
        }
    }
}