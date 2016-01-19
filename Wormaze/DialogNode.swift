 //
//  DialogNode.swift
//  Wormazing
//
//  Created by Oliver Brehm on 28.12.15.
//  Copyright © 2015 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

protocol DialogNodeDelegate
{
    func dialogDidAcceptItem(dialog: DialogNode, item: MenuItem?)
    func dialogDidCancel(dialog: DialogNode)
}

class DialogNode: SKSpriteNode
{
    var items: [MenuItem] = []
    var focus: Int = 0
    
    var delegate: DialogNodeDelegate?
    
    var dialogName = ""
    
    init(size: CGSize, color: SKColor, name: String)
    {
        super.init(texture: nil, color: color, size: size)
        self.zPosition = GameScene.zPositions.Menu
        self.name = name
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
    
    func itemForName(name: String) -> MenuItem? {
        for item in self.items {
            if(item.name == name) {
                return item
            }
        }
        
        return nil
    }
    
    func selectNextItem() {
        if(items.count < 1) {
            return
        }
        
        items[focus].loseFocus()
        focus = (focus + 1) % items.count
        items[focus].setFocus()
    }
    
    func selectedItem() -> MenuItem? {
        if(self.items.count < 1) {
            return nil
        }
        
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
    
    func acceptItem() {
        self.delegate?.dialogDidAcceptItem(self, item: self.selectedItem())
    }
    
    func cancel() {
        self.delegate?.dialogDidCancel(self)
    }
    
    func tapInScene(position: CGPoint) {
        if let s = self.scene {
            let positionInNode = self.convertPoint(position, fromNode: s)
            let tappedNodes = self.nodesAtPoint(positionInNode)
            
            for item in self.items {
                if(tappedNodes.contains(item)) {
                    self.delegate?.dialogDidAcceptItem(self, item: item)
                }
            }
        }
    }
}