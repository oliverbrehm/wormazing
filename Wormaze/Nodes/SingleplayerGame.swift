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

    override func initialize(size: CGSize) {
        super.initialize(size)
        
        scoreLabel.fontSize = 20.0
        scoreLabel.fontColor = SKColor.blackColor()
        scoreLabel.position = CGPoint(x: self.size.width / 2.0, y: self.size.height + scoreLabel.fontSize / 2.0)
        self.addChild(scoreLabel)
        self.updateScore()
    }

    func updateScore()
    {
        scoreLabel.text = "\(Int(score))"
    }
    
    func numOccupiedTilesAroundPoint(x: Int, y: Int) -> Int
    {
        var n = 0
    
        for tile in self.players[0].tiles.tiles {
            if(tile == nil) {
                continue
            }
            
            if(Float.abs(Float(tile!.x - x)) < 3 && Float.abs(Float(tile!.y - y)) < 3) {
                n++
            }
        }
        
        //(self.scene! as! GameScene).debug("n: \(n)")
        
        return n
    }
    
    override func newGame() {
        super.newGame()
        
        self.score = 0.0
        self.updateScore()
    }
    
    override func gameOver() {
        super.gameOver()
    
        self.delegate?.gameBoardGameOver(Int(self.score), message: "Game over. Your score is \(Int(score))!", color: SKColor.redColor())
    }
    
    func numOccupiedTilesAroundHead() -> Int
    {
        let x = self.players[0].tiles.head()!.x
        let y = self.players[0].tiles.head()!.y
        return self.numOccupiedTilesAroundPoint(x, y: y)
    }
    
    override func updateStep(currentTime: CFTimeInterval) {
        super.updateStep(currentTime)
        
        if(self.running) {
            if(self.players.count >= 1) {
                let add = Float(self.players[0].length()) * Float(self.numOccupiedTilesAroundHead())
                score += 1.0 + (add / 100.0)
                
                updateScore()
            }
        
            if(numberOfAlivePlayers() < 1) {
                gameOver()
            }
        }
    }
}