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
    let background = SKColor(red: 0.1, green: 0.3, blue: 0.2, alpha: 1.0)
}

class GameView : SKView, GameSceneDelegate, MenuSceneDelegate, GameControllerDelegate
{
    static let gameColors = GameColors()

    var menuScene : MenuScene?
    var gameScene : GameScene?
    
    var gameControllers: [Controller] = []
    var connectedControllers: [GCController] = []
    
    var gameKitManager: GameKitManager?
    var collectableManager: CollectableManager = CollectableManager()
    
    var coins = 0
    var extralives = 0
    
    let lifeCost = 10
    
    let userDefaultsCoinsKey = "userCoins"
    let userDefaultsLivesKey = "userLives"
    
    //var debugLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 30))
        
    static var instance: GameView?
    
    func initialize()
    {
        GameView.instance = self
        
        /*GameView.instance?.debugLabel.text = ""
        GameView.instance?.debugLabel.textColor = SKColor.redColor()
        GameView.instance?.addSubview(GameView.instance!.debugLabel)*/
        
        self.initializeUserData()
        //self.initializeGameControllers()
    
        self.menuScene = MenuScene(menuDelegate: self)
        self.presentScene(menuScene)
    }
    
    static func debug(msg: String) {
        //instance!.debugLabel.text = msg
    }
    
    func initializeUserData()
    {
        coins = NSUserDefaults.standardUserDefaults().integerForKey(userDefaultsCoinsKey)
        extralives = NSUserDefaults.standardUserDefaults().integerForKey(userDefaultsLivesKey)
    }
    
    func serializeUserData()
    {
        NSUserDefaults.standardUserDefaults().setInteger(coins, forKey: userDefaultsCoinsKey)
        NSUserDefaults.standardUserDefaults().setInteger(extralives, forKey: userDefaultsLivesKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func initializeGameControllers()
    {
        Swift.print("initializing controllers")
        //GameView.debug("initializing controllers")
    
        NSNotificationCenter.defaultCenter().addObserverForName(GCControllerDidConnectNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {(notification: NSNotification) -> Void in
            self.gameControllerConnected(notification)
        })
        
        NSNotificationCenter.defaultCenter().addObserverForName(GCControllerDidDisconnectNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {(notification: NSNotification) -> Void in
            self.gameControllerDisonnected(notification)
        })
        
        self.addControllers()
    }
    
    /*
    func getController(index: Int) -> Controller?
    {
        for(var i = 0; i < self.gameControllers.count; i++) {
            let controller = self.gameControllers[i]
            if(controller.index == index) {
                return self.gameControllers[i]
            }
        }
        
        return nil
    }*/
    
    func addControllers()
    {
        for gameController in GCController.controllers() {
            let controllerIndex = gameControllers.count
            let controller = Controller(name: "mfcController", index: controllerIndex)
            
            if(self.connectedControllers.contains(gameController)) {
                break
            }
            
            self.connectedControllers.append(gameController)

            Swift.print("controller added")
            //GameView.debug("controller added")

            
            gameController.gamepad?.dpad.left.valueChangedHandler = {(CGControllerButtonInput, value: Float, pressed: Bool) -> Void in
                //GameView.debug("left button")
                if(pressed && value > 0.3) {
                    // TODO choose correct controller
                    //GameView.debug("left button pressed, index: \(controllerIndex)")
                    //self.getController(controllerIndex)?.keyDown(.left)
                    self.gameControllers[0].keyDown(.left)
                }
            }
            
            gameController.gamepad?.dpad.right.valueChangedHandler = {(CGControllerButtonInput, value: Float, pressed: Bool) -> Void in
                if(pressed && value > 0.3) {
                    self.gameControllers[0].keyDown(.right)
                    //self.getController(controllerIndex)?.keyDown(.right)
                }
            }
            
            gameController.gamepad?.dpad.up.valueChangedHandler = {(CGControllerButtonInput, value: Float, pressed: Bool) -> Void in
                if(pressed && value > 0.3) {
                    self.gameControllers[0].keyDown(.up)
                    //self.getController(controllerIndex)?.keyDown(.up)
                }
            }
            
            gameController.gamepad?.dpad.down.valueChangedHandler = {(CGControllerButtonInput, value: Float, pressed: Bool) -> Void in
                if(pressed && value > 0.3) {
                    self.gameControllers[0].keyDown(.down)
                    //self.getController(controllerIndex)?.keyDown(.down)
                }
            }
            
            gameController.controllerPausedHandler = {GCController -> Void in
                self.gameControllers[0].keyDown(.cancel)
                //self.getController(controllerIndex)?.keyDown(.cancel)
            }
            
            gameController.extendedGamepad?.buttonA.valueChangedHandler = {(CGControllerButtonInput, value: Float, pressed: Bool) -> Void in
                if(pressed && value > 0.3) {
                    self.gameControllers[0].keyDown(.enter)
                    //self.getController(controllerIndex)?.keyDown(.enter)
                }
            }
            
            // TODO force unwrap
            gameController.playerIndex = GCControllerPlayerIndex(rawValue: controllerIndex)!
            
            self.gameControllers.append(controller)
            
            if let m = self.menuScene {
                controller.assignDialog(m.mainMenu)
            }
        }
    }
    
    func gameControllerConnected(notification: NSNotification) {
        //GameView.debug("controller connected")
        Swift.print("controller connected")
        self.addControllers()
    }
    
    func gameControllerDisonnected(notification: NSNotification) {
        GameView.debug("Controller disconnected")
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
    
    // TODO remove?
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
    
    func playerNotAssigned(controller: Controller) {
        if let s = self.gameScene {
            s.addGameController(controller)
        }
    }
}