//
//  ItemIncSpeed.swift
//  Wormazing
//
//  Created by Oliver Brehm on 11.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class ItemIncSpeed: Collectable {
    static let texture = SKTexture(imageNamed: "speedinc")

    override init(gameboard: GameBoard) {
        super.init(gameboard: gameboard)     
        self.texture = ItemIncSpeed.texture
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func hit(player: Player) {
        super.hit(player)
        player.incrementSpeed()
    }
    
    override func score() -> Float {
        return ItemScores.speedInc
    }
}