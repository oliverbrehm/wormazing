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
    func menuSceneDidStartGame()
}

class MenuScene: SKScene, MainMenuDelegate {
    let menuDelegate : MenuSceneDelegate?
    
    let mainMenu: MainMenu
    
    convenience override init() {
        self.init(menuDelegate: nil)
    }
    
    init(menuDelegate: MenuSceneDelegate?) {
        self.mainMenu = MainMenu()
        self.menuDelegate = menuDelegate
        super.init(size: CGSize(width: 800, height: 600))
        self.backgroundColor = SKColor.redColor()
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
    }
    
    override func update(currentTime: CFTimeInterval) {

    }
    
    func mainMenuDidSelectOption(option: MainMenuOption) {
        if(option == MainMenuOption.StartGame) {
            self.menuDelegate?.menuSceneDidStartGame()
        }
    }

}