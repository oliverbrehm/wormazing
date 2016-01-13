//
//  GameKitManagerOsx.swift
//  Wormazing
//
//  Created by Oliver Brehm on 09.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import GameKit

class GameKitManagerOsx: GameKitManager {
    override func initialize() {
        super.initialize()
        
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = { (viewController: NSViewController?, error: NSError?) -> Void in
            print("autenticating with game center...")
            
            if(viewController != nil) {
                print("not authenticated...")
            } else if(localPlayer.authenticated) {
                localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (identifier: String?, error: NSError?) -> Void in
                    if(error != nil) {
                        print("authenticateHandler: \(error!.description)")
                    } else {
                        print("gamcenter authenticated")
                        self.leaderboardIdentifier = identifier
                        NSNotificationCenter.defaultCenter().postNotificationName(GameKitManager.GameCenterAuthenticatedNotification, object: self)
                    }
                })
            }
            
        }
    }
}