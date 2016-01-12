//
//  MultiplayerGame.swift
//  Wormazing
//
//  Created by Oliver Brehm on 08.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class MultiplayerGame : GameBoard {
    override func step() {
        super.step()
        
        if(running) {
            if(numberOfAlivePlayers() < 2) {
                gameOver()
            }
        }
    }
    
    override func gameOver() {
        super.gameOver()
        
        let winner = self.winningPlayer()
        
        var message = ""
        var color = SKColor.whiteColor()
        
        if(winner == nil) {
            message = "Game over. No winner, no loser."
        } else {
            let colorString = GameScene.playerColors.colorNameForPlayer(winner!)!
            message = "Game over. \(colorString) player wins!"
            color = winner!.color
        }
        
        self.delegate?.gameBoardGameOver(nil, message: message, color: color)
    }
}