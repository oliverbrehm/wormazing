//
//  MenuSceneOsx.swift
//  Wormazing
//
//  Created by Oliver Brehm on 05.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class MenuSceneOsx: MenuScene {
    override func mouseDown(theEvent: NSEvent) {
    }
    
    override func keyDown(theEvent: NSEvent) {
        if(theEvent.keyCode == 0x24) {
            mainMenu.acceptItem()
        }
        
        if theEvent.modifierFlags.contains(NSEventModifierFlags.NumericPadKeyMask) {
            if let theArrow = theEvent.charactersIgnoringModifiers, keyChar = theArrow.unicodeScalars.first?.value{
                switch Int(keyChar){
                case NSUpArrowFunctionKey:
                    mainMenu.selectPreviousItem()
                case NSDownArrowFunctionKey:
                    mainMenu.selectNextItem()
                case NSRightArrowFunctionKey:
                    mainMenu.selectNextItem()
                case NSLeftArrowFunctionKey:
                    mainMenu.selectPreviousItem()
                default:
                    break
                }
            }
        }
    }

}