//
//  GameKitManager.swift
//  Wormazing
//
//  Created by Oliver Brehm on 09.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import GameKit

class GameKitManager
{
    var leaderboardIdentifier: String?

    static let GameCenterNotAuthenticatedNotification = "GameCenterNotAuthenticatedNotification"
    static let GameCenterAuthenticatedNotification = "GameCenterAuthenticatedNotification"

    func initialize()
    {

    }
    
    func reportSingleplayerHighscore(score: Int, completion: () -> Void)
    {
        if(self.leaderboardIdentifier == nil) {
            return
        }
    
        let gkScore = GKScore(leaderboardIdentifier: self.leaderboardIdentifier!)
        gkScore.value = Int64(score)
        
        GKScore.reportScores([gkScore]) { (error: NSError?) -> Void in
            if(error != nil) {
                print("reportSingleplayerHighscore: \(error!.description)")
            } else {
                print("reported highscore \(score).")
                
                GameView.instance?.scene?.runAction(SKAction.waitForDuration(1.0), completion: { () -> Void in
                    completion()
                })
            }
        }
    }
    
    func showLeaderboard()
    {
        if(self.leaderboardIdentifier == nil) {
            return
        }
    
        //let viewController = GKGameCenterViewController()
        // TODO?
        //viewController.gameCenterDelegate = self
        //viewController.viewState = GKGameCenterViewControllerState.Leaderboards
        //viewController.leaderboardIdentifier = self.leaderboardIdentifier!
        
        // TODO present view controller
    }
}