//
//  MainMenu.swift
//  Wormazing
//
//  Created by Oliver Brehm on 28.12.15.
//  Copyright © 2015 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenu : DialogNode
{
    let consumablesNode = PlayerConsumablesNode()
    
    init()
    {
        super.init(size: CGSize(width: 400.0, height: 300.0), color: SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5), name: "MainMenu")
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)        
    }
    
    func addLeaderboard()
    {
        let leaderboard = LeaderboardNode()
        leaderboard.position = CGPoint(x: -self.size.width / 2.0 + leaderboard.size.width / 2.0 + 50.0, y: leaderboard.size.height / 2.0)
        self.addItem(leaderboard)
        leaderboard.initialize()
    }
    
    func gameCenterDidAuthenticate()
    {
        (self.itemForName("leaderboard") as? LeaderboardNode)?.initialize()
    }
    
    func initialize()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("gameCenterDidAuthenticate"), name: GameKitManager.GameCenterAuthenticatedNotification, object: nil)

        self.color = SKColor(white: 1.0, alpha: 0.0)
    
        let logo = SKSpriteNode(imageNamed: "logo")
        logo.position = CGPoint(x: 0.0, y: 80.0 + logo.size.height / 2.0)
        self.addChild(logo)
        
        let growAction = SKAction.scaleTo(1.1, duration: 10.0)
        growAction.timingMode = .EaseInEaseOut
        let shrinkAction = SKAction.scaleTo(1.0, duration: 10.0)
        shrinkAction.timingMode = .EaseInEaseOut
        let pulseAction = SKAction.sequence([growAction, shrinkAction])
        logo.runAction(SKAction.repeatActionForever(pulseAction))
        
        let singlePlayerButton = MenuButton(label: "Sigleplayer", name: "singleplayer");
        singlePlayerButton.position = CGPoint(x: 0.0, y: -50.0)
        singlePlayerButton.initialize()
        self.addItem(singlePlayerButton)

        let testButton = MenuButton(label: "Multiplayer", name: "multiplayer");
        testButton.position = CGPoint(x: 0.0, y: -170.0)
        testButton.initialize()
        self.addItem(testButton)
        
        
        consumablesNode.position = CGPoint(x: -self.size.width / 2.0 + 5.0, y: self.size.height / 2.0 - 5.0)
        consumablesNode.initialize()
        self.addChild(consumablesNode)
        
        let shopButton = MenuButton(label: "Shop", name: "shop");
        shopButton.position = CGPoint(x: 0.0, y: -290.0)
        shopButton.initialize()
        self.addItem(shopButton)

        // TODO if osx
        let exitGameButton = MenuButton(label: "Exit", name: "exitGame");
        exitGameButton.position = CGPoint(x: 0.0, y: -410.0)
        exitGameButton.initialize()
        self.addItem(exitGameButton)
        
        self.addLeaderboard()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}