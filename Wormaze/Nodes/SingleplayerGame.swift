//
//  SinglePlayerGame.swift
//  Wormazing
//
//  Created by Oliver Brehm on 08.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class SingleplayerGame : GameBoard {
    var score: Float = 0.0
    let scoreLabel : SKLabelNode = SKLabelNode(fontNamed: "Chalkduster")

    override func initialize(gameScene: GameScene, size: CGSize) {
        super.initialize(gameScene, size: size)
        
        scoreLabel.fontSize = 30.0
        scoreLabel.fontColor = SKColor.whiteColor()
        scoreLabel.position = CGPoint(x: self.size.width / 2.0, y: self.size.height + scoreLabel.fontSize / 2.0)
        self.addChild(scoreLabel)
        self.updateScoreNode()
    }

    func updateScore()
    {
        let add = Float(self.players[0].length()) * Float(self.players[0].numOccupiedTilesAroundHead())
        score += 1.0 + (add / 100.0)
        updateScoreNode()
    }

    func updateScoreNode()
    {
        scoreLabel.text = "\(Int(score))"
    }
    
    func addScore(score: Float)
    {
        self.score += score
        self.updateScoreNode()
    }
    
    override func newGame() {
        super.newGame()
        
        self.score = 0.0
        self.updateScoreNode()
    }
    
    override func gameOver() {
        super.gameOver()
    
        self.delegate?.gameBoardGameOver(Int(self.score), message: "Game over. Your score is \(Int(score))!", color: SKColor.redColor())
    }
    
    override func step() {
        super.step()
        
        if(self.running) {
            if(numberOfAlivePlayers() < 1) {
                gameOver()
            }
        }
    }
}