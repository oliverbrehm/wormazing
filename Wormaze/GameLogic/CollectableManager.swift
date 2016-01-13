//
//  CollectableManager.swift
//  Wormazing
//
//  Created by Oliver Brehm on 11.01.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

class SpawningWeights
{
    static let grow = 50//100
    static let coin = 100
    static let speedinc = 20
    static let speeddec = 15
    static let invicible = 8
    static let extralive = 6
    
    static func sum() -> Int
    {
        return grow + speedinc + speeddec + invicible + extralive + coin
    }
}

class CollectableManager {
    var current: Collectable?
    
    init()
    {
    }
    
    func getItem() -> Collectable?
    {
        return current
    }
    
    func generate(gameboard: GameBoard)
    {
        let r = Int(arc4random()) % SpawningWeights.sum()
        
        if(r < SpawningWeights.grow) {
            current = ItemGrow(gameboard: gameboard)
        } else if(r < SpawningWeights.grow + SpawningWeights.speedinc) {
            current = ItemIncSpeed(gameboard: gameboard)
        } else if(r < SpawningWeights.grow + SpawningWeights.speedinc + SpawningWeights.speeddec) {
            current = ItemDecSpeed(gameboard: gameboard)
        } else if(r < SpawningWeights.grow + SpawningWeights.speedinc + SpawningWeights.speeddec + SpawningWeights.invicible) {
            current = ItemInvincible(gameboard: gameboard)
        } else if(r < SpawningWeights.grow + SpawningWeights.speedinc + SpawningWeights.speeddec + SpawningWeights.invicible + SpawningWeights.extralive) {
            current = ItemExtralive(gameboard: gameboard)
        } else {
            current = ItemCoin(gameboard: gameboard)
        }
    }
}