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
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var gameView: GameViewOsx!
    
    var fullscreen = false
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        /* Pick a size for the scene */
        gameView.initialize(self.gameView)
        self.window.delegate = self
        CGDisplayHideCursor(0)
    }
    
    func applicationWillTerminate(notification: NSNotification) {
            CGDisplayShowCursor(0)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
    
    func windowDidBecomeMain(notification: NSNotification) {
        if(!self.fullscreen) {
            if((self.window.styleMask & NSFullScreenWindowMask) == 0) {
                self.window.toggleFullScreen(nil)
                self.fullscreen = true
            }
        }
    }
}
