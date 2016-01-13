//
//  PrepareGameNode.swift
//  Wormazing
//
//  Created by Oliver Brehm on 28.12.15.
//  Copyright © 2015 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class PrepareGameNode: DialogNode {
    var text: SKLabelNode?
    
    var playerNodes : [SKLabelNode] = []
    
    var numPlayersJoined : Int = 0
    
    var gameMode = GameMode.singleplayer
    
    var startGameButton: MenuButton?
    
    func initialize(mode: GameMode) {
        self.gameMode = mode
    
        self.startGameButton = MenuButton(label: "Start game", name: "startGame");
        startGameButton!.position = CGPoint(x: 0.0, y: 100.0)
        
        let gameCostNode = CoinsNode()
        gameCostNode.position = CGPoint(x: startGameButton!.size.width / 2.0 + 10.0, y: ItemCoin.texture.size().height / 2.0)
        startGameButton!.addChild(gameCostNode)
        gameCostNode.initialize(GameScene.gameCost)
        gameCostNode.setColor(SKColor.redColor())
        
        text = SKLabelNode(fontNamed: "Chalkduster")
        text!.text = "Press any key on your controller (wasd / hbnm / arrow keys / siri remote)"
        text!.position = CGPoint(x: -0.0, y: 0.0)
        text!.fontColor = SKColor.blackColor()
        self.addChild(text!)
        
        let player1 = SKLabelNode(fontNamed: "Chalkduster")
        player1.color = SKColor.greenColor()
        
        if(gameMode == .singleplayer) {
            player1.text = "waiting..."
        } else if(mode == .multiplayer) {
            player1.text = "Player 1"
        }
        
        player1.position = CGPoint(x: -0.0, y: -100.0)
        player1.fontColor = SKColor.whiteColor()
        player1.fontSize = 18
        self.addChild(player1)
        self.playerNodes.append(player1)
        
        if(gameMode == .multiplayer) {
            let player2 = SKLabelNode(fontNamed: "Chalkduster")
            player2.color = SKColor.orangeColor()
            player2.text = "Player 2"
            player2.position = CGPoint(x: 0.0, y: -200.0)
            player2.fontColor = SKColor.whiteColor()
            player2.fontSize = 18
            self.addChild(player2)
            self.playerNodes.append(player2)
            
            let player3 = SKLabelNode(fontNamed: "Chalkduster")
            player3.color = SKColor.orangeColor()
            player3.text = "Player 3"
            player3.position = CGPoint(x: 0.0, y: -300.0)
            player3.fontColor = SKColor.whiteColor()
            player3.fontSize = 18
            self.addChild(player3)
            self.playerNodes.append(player3)
        }
    }
    
    func showStartGameButton()
    {
        if(gameMode == .singleplayer || (gameMode == .multiplayer && self.numPlayersJoined >= 2)) {
            startGameButton!.initialize()
            self.addItem(startGameButton!)
        }
    }
    
    func arrowKeyPressed(color: SKColor)
    {
        if(numPlayersJoined >= 1 && gameMode == .singleplayer) {
            return
        }
        
        let player = self.playerNodes[self.numPlayersJoined]
        self.numPlayersJoined++
        player.text = "Arrow keys ready..."
        player.fontColor = color
        text?.hidden = false
        self.showStartGameButton()
    }
    
    func wasdPressed(color: SKColor)
    {
        if(numPlayersJoined >= 1 && gameMode == .singleplayer) {
            return
        }
        
        let player = self.playerNodes[self.numPlayersJoined]
        self.numPlayersJoined++
        player.text = "WASD ready..."
        player.fontColor = color
        self.showStartGameButton()
    }
    
    
    func hbnmPressed(color: SKColor)
    {
        if(numPlayersJoined >= 1 && gameMode == .singleplayer) {
            return
        }
        
        let player = self.playerNodes[self.numPlayersJoined]
        self.numPlayersJoined++
        player.text = "HBNM ready..."
        player.fontColor = color
        self.showStartGameButton()
    }
    
    func remoteAdded(color: SKColor) {
        if(numPlayersJoined >= 1 && gameMode == .singleplayer) {
            return
        }
        
        let player = self.playerNodes[self.numPlayersJoined]
        self.numPlayersJoined++
        player.text = "Remote ready..."
        player.fontColor = color
        self.showStartGameButton()
    }
}