//
//  MenuButton.swift
//  Wormazing
//
//  Created by Oliver Brehm on 28.12.15.
//  Copyright © 2015 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class MenuButton: MenuItem {
    var label: String = ""
    
    let DIM_INTENSITY: CGFloat = 0.7
    
    init(label: String, name: String)
    {
        self.label = label
        super.init(image: "button")
        self.name = name
    }
    
    func initialize()
    {
        let labelNode = SKLabelNode(fontNamed: "Chalkduster")
        labelNode.text = self.label
        labelNode.fontSize = 20
        labelNode.fontColor = SKColor.blackColor()
        labelNode.zPosition = self.zPosition + 1
        self.addChild(labelNode)
        self.colorBlendFactor = 0.5
        self.color = SKColor(white: DIM_INTENSITY, alpha: 1.0)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setFocus() {
        self.xScale = 1.2
        self.yScale = 1.2
        
        let glowAction = SKAction.sequence([SKAction.colorizeWithColor(SKColor.whiteColor(), colorBlendFactor: 1.0, duration: 1.5),
                                            SKAction.colorizeWithColor(SKColor(white: DIM_INTENSITY + 0.1, alpha: 1.0), colorBlendFactor: 1.0, duration: 1.5)])
        self.runAction(SKAction.repeatActionForever(glowAction))
    }
    
    override func loseFocus() {
        self.color = SKColor(white: DIM_INTENSITY, alpha: 1.0)
        self.xScale = 1.0
        self.yScale = 1.0
        
        self.removeAllActions()
    }
}