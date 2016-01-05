//
//  AppDelegate.swift
//  Wormaze
//
//  Created by Oliver Brehm on 25.12.15.
//  Copyright (c) 2015 Oliver Brehm. All rights reserved.
//


import Cocoa
import SpriteKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, MenuSceneDelegate, GameSceneDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!
    
    var menuScene : MenuScene?
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        /* Pick a size for the scene */
        menuScene = MenuSceneOsx(menuDelegate: self)
        self.skView!.presentScene(menuScene)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
    
    func menuSceneDidCancel() {
        
    }
    
    func gameSceneDidCancel() {
        // TODO why doesn't resuing the old scene do anything...
        //self.skView!.presentScene(self.menuScene!, transition: SKTransition.crossFadeWithDuration(0.5))
        let m = MenuSceneOsx(menuDelegate: self)
        self.skView!.presentScene(m, transition: SKTransition.crossFadeWithDuration(0.5))
    }
    
    func menuSceneDidStartGame() {
        /* Set the scale mode to scale to fit the window */
        if let scene = GameSceneOsx(fileNamed:"GameScene") {
            scene.scaleMode = .Fill
            scene.gameSceneDelegate = self
                        
            self.skView!.presentScene(scene, transition: SKTransition.crossFadeWithDuration(0.5))
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            self.skView!.ignoresSiblingOrder = true
            
            self.skView!.showsFPS = true
            self.skView!.showsNodeCount = true
        }
    }
}
