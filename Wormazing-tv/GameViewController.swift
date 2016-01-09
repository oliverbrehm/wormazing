//
//  GameViewController.swift
//  Wormazing-tv
//
//  Created by Oliver Brehm on 05.01.16.
//  Copyright (c) 2016 Oliver Brehm. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gameView = self.view as! GameViewTv
        gameView.initialize()
    }
    
    override func viewDidAppear(animated: Bool) {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("showGamecenterAuthenticationViewController"), name: GameKitManager.GameCenterNotAuthenticatedNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showGamecenterAuthenticationViewController()
    {
        if let view = self.view as? GameView {
            if let manager = view.gameKitManager as? GameKitManagerTv {
                if let viewController = manager.authenticationViewController {
                    self.presentViewController(viewController, animated: true, completion: { () -> Void in
                        
                    })
                }
            }
        }
    }
}
