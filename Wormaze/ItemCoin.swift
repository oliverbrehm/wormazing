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
    
    override func attatchToGameboard(x: Int, y: Int, gameBoard: GameBoard) {
        super.attatchToGameboard(x, y: y, gameBoard: gameBoard)
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
        movingCoin.runAction(SKAction.moveTo(gameboard!.convertPoint(gameboard!.consumablesNode.coinsNode.position, fromNode: gameboard!.consumablesNode), duration: 0.5), completion: {
            movingCoin.removeFromParent()
            GameView.instance!.coins++
            self.gameboard!.consumablesNode.update()
        })
    }
    
    override func score() -> Float {
        return ItemScores.coin
    }
}