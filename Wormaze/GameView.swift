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
        // TODO why doesn't resuing the old scene do anything...
        //self.skView!.presentScene(self.menuScene!, transition: SKTransition.crossFadeWithDuration(0.5))
        let m = MenuScene(menuDelegate: self)
        self.presentScene(m, transition: SKTransition.crossFadeWithDuration(0.5))
    }
    
    func menuSceneDidStartGame() {
        /* Set the scale mode to scale to fit the window */
        self.gameScene = GameScene(fileNamed:"GameScene")
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
        return nil
    }
    
    func gameControllerNotAssigned(controller: GameController) {
        if let s = self.gameScene {
            s.addGameController(controller)
        }
    }
}