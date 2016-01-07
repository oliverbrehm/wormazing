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
    let wasdController = GameController(name: "wasdController")
    let hbnmController = GameController(name: "hbnmController")
    let arrowController = GameController(name: "arrowKeysController")
    
    override func initialize() {
        super.initialize()
        
        self.wasdController.delegate = self
        self.hbnmController.delegate = self
        self.arrowController.delegate = self
        
        self.gameControllers.appendContentsOf([wasdController, hbnmController, arrowController])
    }
    
    override func primaryController() -> GameController?
    {
        return wasdController
    }
    
    override func mouseDown(theEvent: NSEvent) {
        /* Called when a mouse click occurs */
        
    }
    
    override func keyDown(theEvent: NSEvent) {
        
        if(theEvent.keyCode == 0x24) {
            self.wasdController.keyDown(.enter)
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
            }
        }
    }
    

}