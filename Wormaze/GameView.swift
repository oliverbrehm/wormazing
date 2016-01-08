//
//  GameView.swift
//  Wormazing
//
//  Created by Oliver Brehm on 07.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class GameView : SKView, GameSceneDelegate, MenuSceneDelegate, GameControllerDelegate
{    
    var menuScene : MenuScene?
    var gameScene : GameScene?
    
    var gameControllers: [GameController] = []
    
    func initialize()
    {
        self.menuScene = MenuScene(menuDelegate: self)
        self.presentScene(menuScene)
    }
    
    func menuSceneDidCancel() {
        
    }
    
    func gameSceneDidCancel() {
        self.menuScene = MenuScene(menuDelegate: self)
        self.presentScene(menuScene!, transition: SKTransition.crossFadeWithDuration(0.5))
    }
    
    func menuSceneDidStartGame(mode: GameMode) {
        self.gameScene = GameScene(fileNamed:"GameScene")
        gameScene!.gameMode = mode
        gameScene!.scaleMode = .Fill
        gameScene!.gameSceneDelegate = self
                    
        self.presentScene(gameScene!, transition: SKTransition.crossFadeWithDuration(0.5))
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        self.ignoresSiblingOrder = true
        
        self.showsFPS = true
        self.showsNodeCount = true
    }
    
    func primaryController() -> GameController?
    {
        return nil // implemented in subclass
    }
    
    func removeAllControls()
    {
        for controler in gameControllers {
            controler.removeControl()
        }
    }
    
    func gameControllerNotAssigned(controller: GameController) {
        if let s = self.gameScene {
            s.addGameController(controller)
        }
    }
}