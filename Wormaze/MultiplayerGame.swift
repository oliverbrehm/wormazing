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
    override func updateStep(currentTime: CFTimeInterval) {
        super.updateStep(currentTime)
        
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
            var colorString = ""
            if(winner!.color == GameScene.playerColors.player1) {
                colorString = GameScene.playerColors.player1ColorName
            } else if(winner!.color == GameScene.playerColors.player2) {
                colorString = GameScene.playerColors.player2ColorName
            } else if(winner!.color == GameScene.playerColors.player3) {
                colorString = GameScene.playerColors.player3ColorName
            } else if(winner!.color == GameScene.playerColors.player4) {
                colorString = GameScene.playerColors.player4ColorName
            }
        
            message = "Game over. \(colorString) player wins!"
            color = winner!.color
        }
        
        self.delegate?.gameBoardGameOver(message, color: color)
    }
}