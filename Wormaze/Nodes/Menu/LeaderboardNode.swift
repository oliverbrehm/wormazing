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

class LeaderboardNode: MenuItem {
    var numEntries = 0

    var numLeaders = 0
    let displayLeaders = 3
    var previousScore : GKScore?
    var displayedMe = false
    var displayedSuccessor = false
    
    init()
    {
        super.init(size: CGSize(width: 300.0, height: 400.0), color: SKColor.whiteColor().colorWithAlphaComponent(0.7), name: "leaderboard")
        self.zPosition = GameScene.zPositions.Menu
        self.anchorPoint = CGPoint(x: 0.5, y: 1.0)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initialize()
    {
        self.removeAllChildren()
    
        GKLeaderboard.loadLeaderboardsWithCompletionHandler {(leaderboards: [GKLeaderboard]?, error: NSError?) -> Void in
            if(error != nil) {
                print("loadLeaderboards: \(error!.description)")
            } else {
                if(leaderboards != nil && leaderboards!.count >= 1) {
                    self.loadLeaderboard(leaderboards![0])
                }
            }
        }
    
        self.addEntry("Loading leaderboard...", color: SKColor.blackColor())
    }
    
    func loadLeaderboard(leaderboard: GKLeaderboard)
    {
        self.removeAllChildren()
        self.numEntries = 0
        
        self.numLeaders = 0
        self.previousScore = nil
        self.displayedMe = false
        self.displayedSuccessor = false
        
        self.addEntry("Leaderboard", color: SKColor.greenColor())
        self.addSpace()
        
        leaderboard.loadScoresWithCompletionHandler { (scores: [GKScore]?, error: NSError?) -> Void in
            if(error != nil) {
                print("loadScores: \(error!.description)")
            } else {
                if(scores != nil) {
                    for score in scores! {
                        self.loadScore(score)
                    }
                }
            }
        }
    }
    
    func loadScore(score: GKScore) {
        if(self.displayedSuccessor) {
            return
        }
        
        if(score.player.playerID == GKLocalPlayer.localPlayer().playerID) {
            self.displayedMe = true
            self.addEntry(score.player.displayName , score: Int(score.value), rank: score.rank, color: SKColor.blueColor())
            return
        }
        
        if(!displayedMe) {
            if(numLeaders >= displayLeaders) {
                return
            } else {
                numLeaders++
            }
        } else {
            self.displayedSuccessor = true
        }
        
        self.addEntry(score.player.displayName , score: Int(score.value), rank: score.rank, color: SKColor.redColor())
        
        if(self.numLeaders == displayLeaders) {
            self.addEntry("...", color: SKColor.redColor())
        }
    }
    
    func addEntry(player: String?, color: SKColor) {
        self.addEntry(player, score: nil, rank: nil, color: color)
    }
    
    func addEntry(player: String?, score: Int?, rank: Int?, color: SKColor)
    {
        if(rank != nil) {
            let rankNode = SKLabelNode(fontNamed: "Chalkduster")
            rankNode.fontColor = color
            rankNode.fontSize = 14.0
            rankNode.position = CGPoint(x: -120.0, y: -20.0 - CGFloat(numEntries) * 40.0)
            rankNode.text = "(\(rank!))"
            self.addChild(rankNode)
        }
        
        let nameNode = SKLabelNode(fontNamed: "Chalkduster")
        nameNode.fontColor = color
        nameNode.fontSize = 14.0
        nameNode.position = CGPoint(x: -0.0, y: -20.0 - CGFloat(numEntries) * 40.0)
        nameNode.text = player
        self.addChild(nameNode)
        
        if(score != nil) {
            let scoreNode = SKLabelNode(fontNamed: "Chalkduster")
            scoreNode.fontColor = color
            scoreNode.fontSize = 14.0
            scoreNode.position = CGPoint(x: 120.0, y: -20.0 - CGFloat(numEntries) * 40.0)
            scoreNode.text = "\(score!)"
            self.addChild(scoreNode)
        }
        
        self.numEntries++
    }
    
    func addSpace()
    {
        self.numEntries++
    }
    
    override func setFocus() {
       self.color = SKColor.redColor().colorWithAlphaComponent(0.5)
    }
    
    override func loseFocus() {
        self.color = SKColor.whiteColor().colorWithAlphaComponent(0.5)
    }
}