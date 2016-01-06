//
//  MenuSceneTv.swift
//  Wormazing
//
//  Created by Oliver Brehm on 05.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import UIKit

class MenuSceneTv: MenuScene {
    var started: Bool = false
    var startingPoint: CGPoint = CGPointZero
    
    let THRESHOLD : CGFloat = 100.0
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        started = true
        
        if let touch = touches.first {
            startingPoint = touch.locationInNode(self)
        }
    }
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        mainMenu.acceptItem()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.locationInNode(self)
            
            let dx = point.x - startingPoint.x
            let dy = point.y - startingPoint.y
            
            if(CGFloat.abs(dx) > THRESHOLD) {
                startingPoint = point
                if(dx > 0) {
                    mainMenu.selectNextItem()
                } else {
                    mainMenu.selectPreviousItem()
                }
            } else if(CGFloat.abs(dy) > THRESHOLD) {
                startingPoint = point
                if(dy < 0) {
                    mainMenu.selectNextItem()
                } else {
                    mainMenu.selectPreviousItem()
                }
            }
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        started = false
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        started = false
    }
}