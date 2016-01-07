 //
//  GameController.swift
//  Wormazing
//
//  Created by Oliver Brehm on 30.12.15.
//  Copyright © 2015 Oliver Brehm. All rights reserved.
//

import Foundation

enum GameKey
{
    case up, down, left, right, enter
}

protocol GameControllerDelegate
{
    func gameControllerNotAssigned(controller: GameController)
}

class GameController
{
    var player: Player?
    var dialog: DialogNode?
    var delegate: GameControllerDelegate?
    
    let name: String
    
    init(name: String) {
        self.name = name
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
    
    func keyDown(key: GameKey)
    {
        if(self.dialog == nil && self.player == nil) {
            self.delegate?.gameControllerNotAssigned(self)
            return
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
        }
    }
}