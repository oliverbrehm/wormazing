//
//  GameView.swift
//  Wormazing
//
//  Created by Oliver Brehm on 07.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit
import GameController

class GameColors
{
    let background = SKColor(red: 0.2, green: 0.6, blue: 0.3, alpha: 1.0)
}

class GameView : SKView, GameSceneDelegate, MenuSceneDelegate, GameControllerDelegate
{
    static let gameColors = GameColors()

    var menuScene : MenuScene?
    var gameScene : GameScene?
    
    var gameControllers: [Controller] = []
    
    var gameKitManager: GameKitManager?
    
    func initialize()
    {    
        self.menuScene = MenuScene(menuDelegate: self)
        self.presentScene(menuScene)
    }
    
    func initializeGameControllers()
    {
        NSNotificationCenter.defaultCenter().addObserverForName(GCControllerDidConnectNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {(notification: NSNotification) -> Void in
            self.gameControllerConnected(notification)
        })
        
        NSNotificationCenter.defaultCenter().addObserverForName(GCControllerDidDisconnectNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {(notification: NSNotification) -> Void in
            self.gameControllerDisonnected(notification)
        })
        
        
        for gameController in GCController.controllers() {
            let controller = Controller(name: "mfcController")
            
            gameController.gamepad?.dpad.left.valueChangedHandler = {(CGControllerButtonInput, Float, pressed: Bool) -> Void in
                if(pressed) {
                    controller.keyDown(.left)
                }
            }
            
            gameController.gamepad?.dpad.right.valueChangedHandler = {(CGControllerButtonInput, Float, pressed: Bool) -> Void in
                if(pressed) {
                    controller.keyDown(.right)
                }
            }
            
            gameController.gamepad?.dpad.up.valueChangedHandler = {(CGControllerButtonInput, Float, pressed: Bool) -> Void in
                if(pressed) {
                    controller.keyDown(.up)
                }
            }
            
            gameController.gamepad?.dpad.down.valueChangedHandler = {(CGControllerButtonInput, Float, pressed: Bool) -> Void in
                if(pressed) {
                    controller.keyDown(.down)
                }
            }
            
            gameController.controllerPausedHandler = {GCController -> Void in
                controller.keyDown(.cancel)
            }
            
            // TODO force unwrap
            gameController.playerIndex = GCControllerPlayerIndex(rawValue: gameControllers.count)!
            
            self.gameControllers.append(controller)
        }
    }
    
    func gameControllerConnected(notification: NSNotification) {
        Swift.print("Controller connected")
        // TODO
    }
    
    func gameControllerDisonnected(notification: NSNotification) {
        Swift.print("Controller disconnected")
        // TODO
    }
    
    func menuSceneDidCancel() {
        // TODO
    }
    
    func gameSceneDidCancel() {
        self.menuScene = MenuScene(menuDelegate: self)
        self.menuScene?.scaleMode = .Fill
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
    
    func primaryController() -> Controller?
    {
        return nil // implemented in subclass
    }
    
    func removeAllControls()
    {
        for controler in gameControllers {
            controler.removeControl()
        }
    }
    
    func gameControllerNotAssigned(controller: Controller) {
        if let s = self.gameScene {
            s.addGameController(controller)
        }
    }
}