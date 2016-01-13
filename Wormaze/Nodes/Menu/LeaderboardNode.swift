//
//  LeaderboardNode.swift
//  Wormazing
//
//  Created by Oliver Brehm on 13.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class LeaderboardNode: SKSpriteNode {
    var numEntries = 0

    init()
    {
        super.init(texture: nil, color: SKColor(white: 1.0, alpha: 0.5), size: CGSize(width: 200.0, height: 600.0))
        self.zPosition = GameScene.zPositions.Menu
        self.anchorPoint = CGPoint(x: 0.5, y: 1.0)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initialize()
    {
        GKLeaderboard.loadLeaderboardsWithCompletionHandler {(leaderboards: [GKLeaderboard]?, error: NSError?) -> Void in
            if(error != nil) {
                print("loadLeaderboards: \(error!.description)")
            } else {
                if(leaderboards != nil && leaderboards!.count >= 1) {
                    self.loadLeaderboard(leaderboards![0])
                }
            }
        }
    
        self.addEntry("Loading leaderboard...", score: 0, color: SKColor.blackColor())
    }
    
    func loadLeaderboard(leaderboard: GKLeaderboard)
    {
        self.removeAllChildren()
    
        if let scores = leaderboard.scores {
            for score in scores {
                self.addEntry(score.player.playerID!, score: Int(score.value), color: SKColor.redColor())
            }
        }
    }
    
    func addEntry(player: String, score: Int, color: SKColor)
    {
        let nameNode = SKLabelNode(fontNamed: "Chalkduster")
        nameNode.fontColor = color
        nameNode.fontSize = 14.0
        nameNode.position = CGPoint(x: -50.0, y: -20.0 - CGFloat(numEntries) * 40.0)
        nameNode.text = player
        self.addChild(nameNode)
        
        let scoreNode = SKLabelNode(fontNamed: "Chalkduster")
        scoreNode.fontColor = color
        scoreNode.fontSize = 14.0
        scoreNode.position = CGPoint(x: 50.0, y: -20.0 - CGFloat(numEntries) * 40.0)
        scoreNode.text = "\(score)"
        self.addChild(scoreNode)
        
        self.numEntries++
    }
    
    func addSpace()
    {
        self.numEntries++
    }
}