//
//  Collectable.swift
//  Wormazing
//
//  Created by Oliver Brehm on 26.12.15.
//  Copyright © 2015 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class Collectable: SKSpriteNode {
    var x, y: Int
    
    init(x: Int, y: Int)
    {
        self.x = x
        self.y = y
        
        super.init(texture: nil, color: NSColor.blueColor(), size: CGSize(width: GameBoard.tileSize, height: GameBoard.tileSize))
        
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.position = CGPoint(x: CGFloat(x) * GameBoard.tileSize, y: CGFloat(y) * GameBoard.tileSize);
        //self.zPosition = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.x = 0
        self.y = 0
        super.init(coder: aDecoder)
    }
}