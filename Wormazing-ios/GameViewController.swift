//
//  GameViewController.swift
//  Wormazing-ios
//
//  Created by Oliver Brehm on 18.01.16.
//  Copyright (c) 2016 Oliver Brehm. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gameView = self.view as! GameViewIOs
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
    /*
        if let view = self.view as? GameView {
            if let manager = view.gameKitManager as? GameKitManagerIOs {
                if let viewController = manager.authenticationViewController {
                    // TODO
                    self.presentViewController(viewController, animated: true, completion: { () -> Void in
                        
                    })
                }
            }
        }*/
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Landscape
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
