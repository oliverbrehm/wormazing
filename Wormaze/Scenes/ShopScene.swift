//
//  ShopScene.swift
//  Wormazing
//
//  Created by Oliver Brehm on 21.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class ShopScene: SKScene, DialogNodeDelegate {
    var shopDialog: DialogNode?
    var consumablesNode: PlayerConsumablesNode?

    override init() {
        super.init(size: CGSize(width: 1920, height: 1080))
        self.backgroundColor = SKColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
     override func didMoveToView(view: SKView) {
        self.shopDialog = DialogNode(size: self.size, color: SKColor(red: 0.3, green: 0.1, blue: 0.2, alpha: 1.0), name: "shopDialog")
        self.addChild(self.shopDialog!)
        self.shopDialog!.delegate = self
        
        consumablesNode = PlayerConsumablesNode()
        consumablesNode!.position = CGPoint(x: -self.size.width / 2.0 + 5.0, y: self.size.height / 2.0 - 5.0)
        consumablesNode!.initialize()
        self.addChild(consumablesNode!)
        
        let buyLivesButton = MenuButton(label: "Get extralife", name: "buyExtralife");
        buyLivesButton.position = CGPoint(x: 0.0, y: 120.0)
        buyLivesButton.initialize()
        self.shopDialog!.addItem(buyLivesButton)
        
        let heart = SKSpriteNode(imageNamed: "extralife")
        buyLivesButton.addChild(heart)
        heart.position = CGPoint(x: -buyLivesButton.size.width / 2.0 - heart.size.width / 2.0 - 10.0, y: 0.0)
        
        let gameCostNode = CoinsNode()
        gameCostNode.position = CGPoint(x: buyLivesButton.size.width / 2.0 + 10.0, y: ItemCoin.texture.size().height / 2.0)
        buyLivesButton.addChild(gameCostNode)
        gameCostNode.initialize(GameScene.gameCost)
        gameCostNode.setColor(SKColor.redColor())
        
        let buyCoinsSmallButton = MenuButton(label: "A few coins", name: "coinsSmall");
        buyCoinsSmallButton.position = CGPoint(x: 0.0, y: 0.0)
        buyCoinsSmallButton.initialize()
        self.shopDialog!.addItem(buyCoinsSmallButton)
        
        let coinsSmallNode = CoinsNode()
        coinsSmallNode.position = CGPoint(x: buyLivesButton.size.width / 2.0 + 10.0, y: ItemCoin.texture.size().height / 2.0)
        buyCoinsSmallButton.addChild(coinsSmallNode)
        coinsSmallNode.initialize(20)
        coinsSmallNode.setColor(SKColor.greenColor())
        
        let buyCoinsBigButton = MenuButton(label: "Lots of coins", name: "coinsBig");
        buyCoinsBigButton.position = CGPoint(x: 0.0, y: -120.0)
        buyCoinsBigButton.initialize()
        self.shopDialog!.addItem(buyCoinsBigButton)
        
        let coinsBigNode = CoinsNode()
        coinsBigNode.position = CGPoint(x: buyLivesButton.size.width / 2.0 + 10.0, y: ItemCoin.texture.size().height / 2.0)
        buyCoinsBigButton.addChild(coinsBigNode)
        coinsBigNode.initialize(50)
        coinsBigNode.setColor(SKColor.greenColor())

        let exitButton = MenuButton(label: "Exit", name: "toMenu");
        exitButton.position = CGPoint(x: 0.0, y: -240.0)
        exitButton.initialize()
        self.shopDialog!.addItem(exitButton)
        
        if let view = self.view as? GameView {
            for controller in view.gameControllers {
                controller.assignDialog(self.shopDialog)
            }
        }
    }

    func dialogDidAcceptItem(dialog: DialogNode, item: MenuItem?) {
        if(item != nil) {
            if(item!.name == "buyExtralife") {
                if(GameView.instance!.buyExtralife()) {
                    self.consumablesNode!.update()
                } else {
                    // TODO not enough coins
                }
            } else if(item!.name == "coinsSmall") {
                GameView.instance!.coins += 20
                self.consumablesNode?.update()
            } else if(item!.name == "coinsBig") {
                GameView.instance!.coins += 50
                self.consumablesNode?.update()
            } else if(item!.name == "toMenu") {
                self.dialogDidCancel(self.shopDialog!)
            }
        }
    }
    
    func dialogDidCancel(dialog: DialogNode) {
        GameView.instance!.shopSceneDidCancel()
    }
}