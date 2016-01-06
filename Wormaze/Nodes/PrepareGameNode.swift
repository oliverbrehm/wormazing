//
//  PrepareGameNode.swift
//  Wormazing
//
//  Created by Oliver Brehm on 28.12.15.
//  Copyright © 2015 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

protocol PrepareGameNodeDelegate
{
    func prepareGameNodeDidContinue()
}

class PrepareGameNode: DialogNode {
    var delegate: PrepareGameNodeDelegate?
    
    var text, player1, player2, player3, player4: SKLabelNode?
    
    var playerJoined = false
    
    func initialize() {
        text = SKLabelNode(fontNamed: "Chalkduster")
        text!.text = "Press enter to start game"
        text!.position = CGPoint(x: -0.0, y: 100.0)
        text!.fontColor = SKColor.blackColor()
        self.addChild(text!)
        text?.hidden = true
        
        player1 = SKLabelNode(fontNamed: "Chalkduster")
        player1!.color = SKColor.greenColor()
        player1!.text = "Press WASD to join"
        player1!.position = CGPoint(x: -0.0, y: 0.0)
        player1!.fontColor = SKColor.whiteColor()
        player1!.fontSize = 18
        self.addChild(player1!)
        
        player2 = SKLabelNode(fontNamed: "Chalkduster")
        player2!.color = SKColor.orangeColor()
        player2!.text = "Press arrow keys to join"
        player2!.position = CGPoint(x: 0.0, y: -100.0)
        player2!.fontColor = SKColor.whiteColor()
        player2!.fontSize = 18
        self.addChild(player2!)
        
        player3 = SKLabelNode(fontNamed: "Chalkduster")
        player3!.color = SKColor.orangeColor()
        player3!.text = "Press HBNM to join"
        player3!.position = CGPoint(x: 0.0, y: -200.0)
        player3!.fontColor = SKColor.whiteColor()
        player3!.fontSize = 18
        self.addChild(player3!)
        
        player4 = SKLabelNode(fontNamed: "Chalkduster")
        player4!.color = SKColor.orangeColor()
        player4!.text = "Add remote"
        player4!.position = CGPoint(x: 0.0, y: -300.0)
        player4!.fontColor = SKColor.whiteColor()
        player4!.fontSize = 18
        self.addChild(player4!)
    }
    
    func wasdPressed(color: SKColor)
    {
        player1?.text = "WASD ready..."
        player1?.fontColor = color
        playerJoined = true
        text?.hidden = false
    }
    
    func arrowKeyPressed(color: SKColor)
    {
        player2?.text = "Arrow keys ready..."
        player2?.fontColor = color
        playerJoined = true
        text?.hidden = false
    }
    
    func hbnmPressed(color: SKColor)
    {
        player3?.text = "HBNM ready..."
        player3?.fontColor = color
        playerJoined = true
        text?.hidden = false
    }
    
    func remoteAdded(color: SKColor) {
        player4?.text = "Remote ready..."
        player4?.fontColor = color
        playerJoined = true
        text?.hidden = false
    }
    
    func enterPressed()
    {
        if(self.playerJoined) {
            self.delegate?.prepareGameNodeDidContinue()
        }
    }
}