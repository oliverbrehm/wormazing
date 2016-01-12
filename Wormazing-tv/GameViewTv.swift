//
//  GameViewTv.swift
//  Wormazing
//
//  Created by Oliver Brehm on 07.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class GameViewTv : GameView
{
    var started: Bool = false
    var startingPoint: CGPoint = CGPointZero
    
    let THRESHOLD : CGFloat = 100.0
    
    let siriRemoteController = Controller(name: "siriRemoteController")
    
    override func initialize() {
        super.initialize()
        
        self.gameKitManager = GameKitManagerTv()
        self.gameKitManager!.initialize()
        
        self.siriRemoteController.delegate = self
        
        self.gameControllers.append(siriRemoteController)
    }
    
    override func primaryController() -> Controller? {
        return siriRemoteController
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        started = true
                
        if let touch = touches.first {
            startingPoint = touch.locationInNode(self.scene!)
        }
    }
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        switch(presses.first!.type) {
            case UIPressType.Menu:
                siriRemoteController.keyDown(.cancel)
            case UIPressType.Select:
                siriRemoteController.keyDown(.enter)
            case UIPressType.PlayPause:
                siriRemoteController.keyDown(.action)
            default:
                break
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
                    siriRemoteController.keyDown(GameKey.right)
                } else {
                    siriRemoteController.keyDown(GameKey.left)
                }
            } else if(CGFloat.abs(dy) > THRESHOLD) {
                startingPoint = point
                if(dy < 0) {
                    siriRemoteController.keyDown(GameKey.down)
                } else {
                    siriRemoteController.keyDown(GameKey.up)
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