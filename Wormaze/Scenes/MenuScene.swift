//
//  MenuScene.swift
//  Wormazing
//
//  Created by Oliver Brehm on 28.12.15.
//  Copyright © 2015 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene, DialogNodeDelegate {
    let mainMenu: MainMenu
    
    override init() {
        self.mainMenu = MainMenu()
        super.init(size: CGSize(width: 1920, height: 1080))
        self.backgroundColor = GameView.gameColors.background
        self.mainMenu.delegate = self
        self.mainMenu.size = self.size
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.mainMenu = MainMenu()
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
        if(self.children.count <= 0) {
            self.addChild(mainMenu)
            self.mainMenu.initialize()
        }
        
        if let view = self.view as? GameView {
            view.primaryController()?.removeControl()
            view.primaryController()?.assignDialog(self.mainMenu)
        }
        
        (self.view as! GameView).primaryController()!.assignDialog(self.mainMenu)
        (self.view as! GameView).initializeGameControllers()
        
        self.mainMenu.consumablesNode.update()
    }
    
    override func update(currentTime: CFTimeInterval) {

    }
    
    func dialogDidAcceptItem(dialog: DialogNode, item: MenuItem?) {
        if(item == nil) {
            return
        }
        
        if(item!.name == "singleplayer") {
            GameView.instance!.menuSceneDidStartGame(.singleplayer)
        } else if(item!.name == "multiplayer") {
            GameView.instance!.menuSceneDidStartGame(.multiplayer)
        } else if(item!.name == "shop") {
            GameView.instance!.displayShopScene()
        } else if(item!.name == "exitGame") {
            exit(EXIT_SUCCESS)
        }
    }
    
    func dialogDidCancel(dialog: DialogNode) {
    // TODO
    }
}