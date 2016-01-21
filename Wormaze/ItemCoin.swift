//
//  ItemCoin.swift
//  Wormazing
//
//  Created by Oliver Brehm on 13.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class ItemCoin: Collectable {
    static let texture = SKTexture(imageNamed: "coin")

    override init(gameboard: GameBoard) {
        super.init(gameboard: gameboard)
    }
    
    override func attatchToGameboard(x: Int, y: Int) {
        super.attatchToGameboard(x, y: y)
        self.texture = ItemCoin.texture
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func hit(player: Player) {
        super.hit(player)
        
        let movingCoin = SKSpriteNode(texture: ItemCoin.texture)
        movingCoin.position = self.position
        movingCoin.zPosition = GameScene.zPositions.GameboardOverlay
        gameboard?.addChild(movingCoin)
        
        let pointInScene = gameboard!.gameScene!.convertPoint(gameboard!.gameScene!.consumablesNode.coinsNode.position, fromNode: gameboard!.gameScene!.consumablesNode)
        let pointInGameboard = gameboard!.gameScene!.convertPoint(pointInScene, toNode: gameboard!)
        
        movingCoin.runAction(SKAction.moveTo(pointInGameboard, duration: 0.5), completion: {
            movingCoin.removeFromParent()
            GameView.instance!.coins++
            self.gameboard!.gameScene!.consumablesNode.update()
        })
    }
    
    override func score() -> Float {
        return ItemScores.coin
    }
}