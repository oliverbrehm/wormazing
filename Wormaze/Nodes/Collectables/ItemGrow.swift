//
//  ItemGrow.swift
//  Wormazing
//
//  Created by Oliver Brehm on 11.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class ItemGrow: Collectable {
    static let texture = SKTexture(imageNamed: "grow")

    override init(gameboard: GameBoard) {
        super.init(gameboard: gameboard)
    }
    
    override func attatchToGameboard(x: Int, y: Int) {
        super.attatchToGameboard(x, y: y)
        self.texture = ItemGrow.texture
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func hit(player: Player) {
        super.hit(player)
        player.grow(5)
    }
    
    override func score() -> Float {
        return ItemScores.grow
    }
}