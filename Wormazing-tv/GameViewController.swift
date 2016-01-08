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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
