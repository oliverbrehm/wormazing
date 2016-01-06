//
//  GameViewController.swift
//  Wormazing-tv
//
//  Created by Oliver Brehm on 05.01.16.
//  Copyright (c) 2016 Oliver Brehm. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, MenuSceneDelegate, GameSceneDelegate {
    
    var menuScene : MenuScene?
    var gameScene : GameScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Pick a size for the scene */
        menuScene = MenuSceneTv(menuDelegate: self)
        let skView = self.view as! SKView
        skView.presentScene(menuScene)

        /*if let scene = GameScene(fileNamed: "GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func menuSceneDidCancel() {
        
    }
    
    func gameSceneDidCancel() {
        // TODO why doesn't resuing the old scene do anything...
        //self.skView!.presentScene(self.menuScene!, transition: SKTransition.crossFadeWithDuration(0.5))
        self.menuScene = MenuSceneTv(menuDelegate: self)
        let skView = self.view as! SKView
        skView.presentScene(self.menuScene!, transition: SKTransition.crossFadeWithDuration(0.5))
        self.gameScene = nil
    }
    
    func menuSceneDidStartGame() {
        /* Set the scale mode to scale to fit the window */
        gameScene = GameSceneTv(fileNamed:"GameScene")
        if(gameScene != nil) {
            gameScene!.scaleMode = .Fill
            gameScene!.gameSceneDelegate = self
            
            let skView = self.view as! SKView
            
            skView.presentScene(gameScene!, transition: SKTransition.crossFadeWithDuration(0.5))
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            self.menuScene = nil
        }
    }
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        self.menuScene?.pressesBegan(presses, withEvent: event)
        self.gameScene?.pressesBegan(presses, withEvent: event)
    }
}
