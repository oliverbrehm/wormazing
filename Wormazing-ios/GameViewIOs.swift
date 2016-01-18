//
//  GameViewIOs.swift
//  Wormazing
//
//  Created by Oliver Brehm on 18.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class GameViewIOs : GameView
{
    var started: Bool = false
    var startingPoint: CGPoint = CGPointZero
    
    let THRESHOLD : CGFloat = 100.0
    
    let touchController = Controller(name: "touchController", index: 0)
    
    override func initialize() {
        super.initialize()
        
        self.gameKitManager = GameKitManagerIOs()
        self.gameKitManager!.initialize()
        
        self.touchController.delegate = self
        
        self.gameControllers.append(touchController)
    }
    
    override func primaryController() -> Controller? {
        return touchController
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        started = true
                
        if let touch = touches.first {
            startingPoint = touch.locationInNode(self.scene!)
            
            // TODO use gesture recognizer
            self.touchController.tapInScene(startingPoint)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.locationInNode(self.scene!)
            
            let dx = point.x - startingPoint.x
            let dy = point.y - startingPoint.y
            
            if(CGFloat.abs(dx) > THRESHOLD) {
                startingPoint = point
                if(dx > 0) {
                    touchController.keyDown(GameKey.right)
                } else {
                    touchController.keyDown(GameKey.left)
                }
            } else if(CGFloat.abs(dy) > THRESHOLD) {
                startingPoint = point
                if(dy < 0) {
                    touchController.keyDown(GameKey.down)
                } else {
                    touchController.keyDown(GameKey.up)
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