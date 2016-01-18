//
//  GameKitManagerIOs.swift
//  Wormazing
//
//  Created by Oliver Brehm on 18.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import GameKit

class GameKitManagerIOs: GameKitManager {
    var authenticationViewController: UIViewController?

    override func initialize() {
        super.initialize()
        
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = { (viewController: UIViewController?, error: NSError?) -> Void in
            print("autenticating with game center...")
            
            if(viewController != nil) {
                print("not authenticated...")
                self.authenticationViewController = viewController!
                NSNotificationCenter.defaultCenter().postNotificationName(GameKitManager.GameCenterNotAuthenticatedNotification, object: self)
            } else if(localPlayer.authenticated) {
                localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (identifier: String?, error: NSError?) -> Void in
                    if(error != nil) {
                        print(error)
                    } else {
                        self.leaderboardIdentifier = identifier
                        NSNotificationCenter.defaultCenter().postNotificationName(GameKitManager.GameCenterAuthenticatedNotification, object: self)
                    }
                })
            }

        }
    }
}