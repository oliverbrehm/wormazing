//
//  MenuScene.swift
//  Wormazing
//
//  Created by Oliver Brehm on 28.12.15.
//  Copyright © 2015 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

protocol MenuSceneDelegate
{
    func menuSceneDidCancel()
    func menuSceneDidStartGame(mode: GameMode)
}

class MenuScene: SKScene, DialogNodeDelegate {
    let menuDelegate : MenuSceneDelegate?
    
    let mainMenu: MainMenu
    
    convenience override init() {
        self.init(menuDelegate: nil)
    }
    
    init(menuDelegate: MenuSceneDelegate?) {
        self.mainMenu = MainMenu()
        self.menuDelegate = menuDelegate
        super.init(size: CGSize(width: 1920, height: 1080))
        self.backgroundColor = SKColor.blackColor()
        self.mainMenu.delegate = self
        self.mainMenu.size = self.size
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.menuDelegate = nil
        self.mainMenu = MainMenu()
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
        self.addChild(mainMenu)
        self.mainMenu.initialize()
        
        if let view = self.view as? GameView {
            view.primaryController()?.removeControl()
            view.primaryController()?.assignDialog(self.mainMenu)
        }
        
        (self.view as! GameView).primaryController()!.assignDialog(self.mainMenu)
    }
    
    override func update(currentTime: CFTimeInterval) {

    }
    
    func dialogDidAcceptItem(dialog: DialogNode, item: MenuItem?) {
        if(item == nil) {
            return
        }
        
        if(item!.name == "singleplayer") {
            self.menuDelegate?.menuSceneDidStartGame(.singleplayer)
        } else if(item!.name == "multiplayer") {
            self.menuDelegate?.menuSceneDidStartGame(.multiplayer)
        } else if(item!.name == "exitGame") {
            exit(EXIT_SUCCESS)
        }
    }
    
    func dialogDidCancel(dialog: DialogNode) {
    // TODO
    }
}