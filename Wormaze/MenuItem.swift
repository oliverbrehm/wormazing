//
//  MenuItem.swift
//  Wormazing
//
//  Created by Oliver Brehm on 28.12.15.
//  Copyright © 2015 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class MenuItem: SKSpriteNode {
    init(size: CGSize, name: String)
    {
        super.init(texture: nil, color: SKColor.darkGrayColor(), size: size)
        self.name = name
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setFocus() {}
    func loseFocus() {}
    
}