//
//  ItemInvincible.swift
//  Wormazing
//
//  Created by Oliver Brehm on 11.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class ItemInvincible: Collectable {
    static let texture = SKTexture(imageNamed: "extrainvincible")

    override init(gameboard: GameBoard) {
        super.init(gameboard: gameboard)
    }
    
    override func attatchToGameboard(x: Int, y: Int, gameBoard: GameBoard) {
        super.attatchToGameboard(x, y: y, gameBoard: gameBoard)
        self.texture = ItemInvincible.texture
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func hit(player: Player) {
        super.hit(player)
        player.addInvincibility()
    }
    
    override func score() -> Float {
        return ItemScores.invincible
    }
}