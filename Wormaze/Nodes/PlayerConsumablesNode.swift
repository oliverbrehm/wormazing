//
//  PlayerConsumablesNode.swift
//  Wormazing
//
//  Created by Oliver Brehm on 21.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class PlayerConsumablesNode: SKSpriteNode {
    let coinsNode = CoinsNode()
    let livesNode = LivesNode()
    
    func initialize()
    {
        coinsNode.position = CGPoint(x: 5.0, y: 0.0)
        self.addChild(coinsNode)
        coinsNode.initialize(GameView.instance!.coins)
        
        livesNode.position = CGPoint(x: 200.0, y: 0.0)
        self.addChild(livesNode)
        livesNode.initialize(GameView.instance!.extralives)
    }
    
    func update()
    {
        self.coinsNode.update(GameView.instance!.coins)
        self.livesNode.update(GameView.instance!.extralives)
    }
}