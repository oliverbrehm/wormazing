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
    
    init(size: CGSize, label: String, name: String)
    {
        self.label = label
        super.init(size: size, name: name)
    }
    
    func initialize()
    {
        let labelNode = SKLabelNode(fontNamed: "Chalkduster")
        labelNode.text = self.label
        labelNode.fontSize = 20
        labelNode.fontColor = SKColor.greenColor()
        self.addChild(labelNode)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setFocus() {
        self.color = SKColor.blueColor()
    }
    
    override func loseFocus() {
        self.color = SKColor.darkGrayColor()
    }
}