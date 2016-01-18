 //
//  GameController.swift
//  Wormazing
//
//  Created by Oliver Brehm on 30.12.15.
//  Copyright © 2015 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

enum GameKey
{
    case up, down, left, right, enter, cancel, action
}

protocol GameControllerDelegate
{
    func playerNotAssigned(controller: Controller)
}

class Controller
{
    var player: Player?
    var dialog: DialogNode?
    var delegate: GameControllerDelegate?
    
    let name: String
    let index: Int
    
    init(name: String, index: Int) {
        self.name = name
        self.index = index
    }
    
    func assignPlayer(player: Player?)
    {
        self.player = player
    }
    
    func assignDialog(dialog: DialogNode?)
    {
        self.dialog = dialog
    }
    
    func removeControl()
    {
        self.player = nil
        self.dialog = nil
    }
    
    func isAssigned() -> Bool
    {
        return (self.player != nil && self.dialog != nil)
    }
    
    func keyDown(key: GameKey)
    {
        if(self.player == nil && (key == .up || key == .down || key == .left || key == .right)) {
            self.delegate?.playerNotAssigned(self)
        }
    
        switch(key) {
        case .up:
            self.player?.navigate(PlayerDirection.up)
            self.dialog?.selectPreviousItem()
        case .down:
            self.player?.navigate(PlayerDirection.down)
            self.dialog?.selectNextItem()
        case .left:
            self.player?.navigate(PlayerDirection.left)
            self.dialog?.selectPreviousItem()
        case .right:
            self.player?.navigate(PlayerDirection.right)
            self.dialog?.selectNextItem()
        case .enter:
            self.dialog?.acceptItem()
        case .cancel:
            self.player?.pause()
            self.dialog?.cancel()
        case .action:
            self.player?.useInvincibility()
        }
    }
    
    func tapInScene(position: CGPoint)
    {
        self.dialog?.tapInScene(position)
    }
}