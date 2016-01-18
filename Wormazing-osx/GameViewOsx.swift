         //
//  GameViewOsx.swift
//  Wormazing
//
//  Created by Oliver Brehm on 07.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class GameViewOsx : GameView
{
    let wasdController = Controller(name: "wasdController")
    let hbnmController = Controller(name: "hbnmController")
    let arrowController = Controller(name: "arrowKeysController")
    
    override func initialize() {
        super.initialize()
        
        self.gameKitManager = GameKitManagerOsx()
        self.gameKitManager!.initialize()
        
        self.wasdController.delegate = self
        self.hbnmController.delegate = self
        self.arrowController.delegate = self
        
        self.gameControllers.appendContentsOf([wasdController, hbnmController, arrowController])
    }
    
    override func primaryController() -> Controller?
    {
        return arrowController
    }
    
    override func keyDown(theEvent: NSEvent) {
        
        if(theEvent.keyCode == 0x24) { // return key
            if(wasdController.isAssigned()) {
                wasdController.keyDown(.enter)
            } else if(hbnmController.isAssigned()) {
                hbnmController.keyDown(.enter)
            } else {
                arrowController.keyDown(.enter)
            }
        }
        
        if(theEvent.keyCode == 0x35) { // escape key
            if(wasdController.isAssigned()) {
                wasdController.keyDown(.cancel)
            } else if(hbnmController.isAssigned()) {
                hbnmController.keyDown(.cancel)
            } else {
                arrowController.keyDown(.cancel)
            }
        }
        
        if(theEvent.keyCode == 0x77) { // end key
            arrowController.keyDown(.action)
        }
    
        if theEvent.modifierFlags.contains(NSEventModifierFlags.NumericPadKeyMask) {
            if let theArrow = theEvent.charactersIgnoringModifiers, keyChar = theArrow.unicodeScalars.first?.value{
                
                // arrow keys controller
                switch Int(keyChar){
                case NSUpArrowFunctionKey:
                    self.arrowController.keyDown(.up)
                case NSDownArrowFunctionKey:
                    self.arrowController.keyDown(.down)
                case NSRightArrowFunctionKey:
                    self.arrowController.keyDown(.right)
                case NSLeftArrowFunctionKey:
                    self.arrowController.keyDown(.left)
                default:
                    break
                }
            }
        }
        
        if let c = theEvent.characters {
            // wasd controller
            if c.containsString("w") {
                self.wasdController.keyDown(.up)
            } else if c.containsString("a") {
                self.wasdController.keyDown(.left)
            } else if c.containsString("s") {
                self.wasdController.keyDown(.down)
            } else if c.containsString("d") {
                self.wasdController.keyDown(.right)
            } else if(c.containsString("e")) {
                self.wasdController.keyDown(.action)
            }
            
            // hbnm controller
            if c.containsString("h") {
                self.hbnmController.keyDown(.up)
            } else if c.containsString("b") {
                self.hbnmController.keyDown(.left)
            } else if c.containsString("n") {
                self.hbnmController.keyDown(.down)
            } else if c.containsString("m") {
                self.hbnmController.keyDown(.right)
            } else if(c.containsString("j")) {
                self.hbnmController.keyDown(.action)
            }
        }
    }
    

}