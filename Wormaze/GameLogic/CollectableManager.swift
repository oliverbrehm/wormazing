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
    static let grow = 100
    static let speedinc = 20
    static let speeddec = 15
    static let invicible = 6
    static let extralive = 4
    
    static func sum() -> Int
    {
        return grow + speedinc + speeddec + invicible + extralive
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
    
    func generate()
    {
        let r = Int(arc4random()) % SpawningWeights.sum()
        
        if(r < SpawningWeights.grow) {
            current = ItemGrow()
        } else if(r < SpawningWeights.grow + SpawningWeights.speedinc) {
            current = ItemIncSpeed()
        } else if(r < SpawningWeights.grow + SpawningWeights.speedinc + SpawningWeights.speeddec) {
            current = ItemDecSpeed()
        } else if(r < SpawningWeights.grow + SpawningWeights.speedinc + SpawningWeights.speeddec + SpawningWeights.invicible) {
            current = ItemInvincible()
        } else {
            current = ItemExtralive()
        }    
    }
}