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
    func prepareGameNodeAddedPlayer(id: Int)
    func prepareGameNodeDidContinue()
}

class PrepareGameNode: DialogNode {
    var delegate: PrepareGameNodeDelegate?
    
    var text, player1, player2: SKLabelNode?
    
    var playerJoined = false
    
    func initialize() {
        text = SKLabelNode(fontNamed: "Chalkduster")
        text!.text = "Press enter to start game"
        text!.position = CGPoint(x: -0.0, y: 100.0)
        text!.fontColor = SKColor.blackColor()
        self.addChild(text!)
        
        player1 = SKLabelNode(fontNamed: "Chalkduster")
        player1!.color = SKColor.greenColor()
        player1!.text = "Press WASD to join"
        player1!.position = CGPoint(x: -200.0, y: 0.0)
        player1!.fontColor = SKColor.greenColor()
        player1!.fontSize = 18
        self.addChild(player1!)
        
        player2 = SKLabelNode(fontNamed: "Chalkduster")
        player2!.color = SKColor.orangeColor()
        player2!.text = "Press arrow keys to join"
        player2!.position = CGPoint(x: 200.0, y: 0.0)
        player2!.fontColor = SKColor.orangeColor()
        player2!.fontSize = 18
        self.addChild(player2!)
    }
    
    func wasdPressed()
    {
        player1?.text = "OK"
        //player1?.fontColor = SKColor.whiteColor()
        self.delegate?.prepareGameNodeAddedPlayer(0)
        playerJoined = true
    }
    
    func arrowKeyPressed()
    {
        player2?.text = "OK"
        //player2?.fontColor = SKColor.whiteColor()
        self.delegate?.prepareGameNodeAddedPlayer(1)
        playerJoined = true
    }
    
    func enterPressed()
    {
        if(self.playerJoined) {
            self.delegate?.prepareGameNodeDidContinue()
        }
    }
}