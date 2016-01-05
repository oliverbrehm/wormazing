//
//  GameSceneOsx.swift
//  Wormazing
//
//  Created by Oliver Brehm on 05.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class GameSceneOsx : GameScene
{
    
    override func mouseDown(theEvent: NSEvent) {
        /* Called when a mouse click occurs */
        
    }
    
    override func keyDown(theEvent: NSEvent) {
        
        if(theEvent.keyCode == 0x24) {
            // enter key
            switch self.gameState
            {
            case .PrepareGame:
                self.prepareGameNode?.enterPressed()
            case .GameOver:
                self.gameOverNode?.acceptItem()
            default:
                break
            }
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