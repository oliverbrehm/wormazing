//
//  GameSceneTv.swift
//  Wormazing
//
//  Created by Oliver Brehm on 05.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import UIKit

class GameSceneTv: GameScene
{    
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
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.locationInNode(self)
            
            let dx = point.x - startingPoint.x
            let dy = point.y - startingPoint.y
            
            if(CGFloat.abs(dx) > THRESHOLD) {
                startingPoint = point
                if(dx > 0) {
                    remotControl.keyDown(GameKey.right)
                } else {
                    remotControl.keyDown(GameKey.left)
                }
            } else if(CGFloat.abs(dy) > THRESHOLD) {
                startingPoint = point
                if(dy < 0) {
                    remotControl.keyDown(GameKey.down)
                } else {
                    remotControl.keyDown(GameKey.up)
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