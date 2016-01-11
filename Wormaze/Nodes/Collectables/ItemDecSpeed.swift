//
//  ItemDecSpeed.swift
//  Wormazing
//
//  Created by Oliver Brehm on 11.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class ItemDecSpeed: Collectable {
    static let texture = SKTexture(imageNamed: "speeddec")

    override init() {
        super.init()
        self.texture = ItemDecSpeed.texture
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func hit(player: Player) {
        player.decrementSpeed()
    }
}