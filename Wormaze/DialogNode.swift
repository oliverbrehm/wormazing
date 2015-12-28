//
//  DialogNode.swift
//  Wormazing
//
//  Created by Oliver Brehm on 28.12.15.
//  Copyright © 2015 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class DialogNode: SKSpriteNode
{
    var items: [MenuItem] = []
    var focus: Int = 0
    
    init()
    {
        super.init(texture: nil, color: SKColor.blackColor(), size: CGSizeZero)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addItem(item: MenuItem) {
        self.items.append(item)
        self.addChild(item)
        if(self.items.count == 1) {
            item.setFocus()
        }
    }
    
    func selectNextItem() {
        if(items.count < 1) {
            return
        }
        
        items[focus].loseFocus()
        focus = (focus + 1) % items.count
        items[focus].setFocus()
    }
    
    func selectedItem() -> MenuItem {
        return items[focus]
    }
    
    func selectPreviousItem() {
        if(items.count < 1) {
            return
        }
        
        items[focus].loseFocus()
        focus--
        if(focus < 0) {
            focus = items.count - 1
        }
        items[focus].setFocus()
    }
}