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
    static let texture = SKTexture(imageNamed: "invincible")

    override init() {
        super.init()
    }
    
    override func attatchToGameboard(x: Int, y: Int, gameBoard: GameBoard) {
        super.attatchToGameboard(x, y: y, gameBoard: gameBoard)
        //self.texture = ItemGrow.texture
        self.color = SKColor.blueColor()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func hit(player: Player) {
        player.addInvincibility()
    }
}