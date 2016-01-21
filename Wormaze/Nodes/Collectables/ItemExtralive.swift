//
//  ItemExtralive.swift
//  Wormazing
//
//  Created by Oliver Brehm on 11.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class ItemExtralive: Collectable {
    static let texture = SKTexture(imageNamed: "extralife")

    override init(gameboard: GameBoard) {
        super.init(gameboard: gameboard)
    }
    
    override func attatchToGameboard(x: Int, y: Int) {
        super.attatchToGameboard(x, y: y)
        self.texture = ItemExtralive.texture
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func hit(player: Player) {
        super.hit(player)
        
        let movingHeart = SKSpriteNode(texture: ItemExtralive.texture)
        movingHeart.position = self.position
        movingHeart.zPosition = GameScene.zPositions.GameboardOverlay
        gameboard?.addChild(movingHeart)
        
        let pointInScene = gameboard!.gameScene!.convertPoint(gameboard!.gameScene!.consumablesNode.livesNode.position, fromNode: gameboard!.gameScene!.consumablesNode)
        let pointInGameboard = gameboard!.gameScene!.convertPoint(pointInScene, toNode: gameboard!)
        
        movingHeart.runAction(SKAction.moveTo(pointInGameboard, duration: 0.5), completion: {
            movingHeart.removeFromParent()
            player.addLive()
        })
        
    }
    
    override func score() -> Float {
        return ItemScores.extralife
    }
}