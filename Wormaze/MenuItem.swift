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
    init(size: CGSize, color: SKColor, name: String)
    {
        super.init(texture: nil, color: color, size: size)
        self.name = name
        self.zPosition = GameScene.zPositions.Menu
    }
    
    init(image: String) {
        super.init(texture: nil, color: SKColor.blackColor(), size: CGSizeZero)
        self.texture = SKTexture(imageNamed: image)
        self.size = self.texture!.size()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setFocus() {}
    func loseFocus() {}
    
}