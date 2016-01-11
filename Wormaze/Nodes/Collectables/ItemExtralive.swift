//
//  ItemExtralive.swift
//  Wormazing
//
//  Created by Oliver Brehm on 11.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class ItemExtralive: Collectable {
    static let texture = SKTexture(imageNamed: "extralive")

    override init() {
        super.init()
    }
    
    override func attatchToGameboard(x: Int, y: Int, gameBoard: GameBoard) {
        super.attatchToGameboard(x, y: y, gameBoard: gameBoard)
        //self.texture = ItemGrow.texture
        self.color = SKColor.redColor()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func hit(player: Player) {
        player.addLive()
    }
}