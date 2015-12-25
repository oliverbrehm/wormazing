//
//  GameScene.swift
//  Wormaze
//
//  Created by Oliver Brehm on 25.12.15.
//  Copyright (c) 2015 Oliver Brehm. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    static let stepTime: CFTimeInterval = 0.1
    
    var lastStepTime: CFTimeInterval = 0;
    var currentTime: CFTimeInterval = 0;
    
    let gameBoard = GameBoard(tilesX: 65, tilesY: 40)
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = SKColor.brownColor()
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        
        self.addChild(gameBoard)
        gameBoard.initialize()
        
        gameBoard.position = CGPoint(x: -gameBoard.size.width / 2, y: -gameBoard.size.height / 2);
    }
    
    override func mouseDown(theEvent: NSEvent) {
        /* Called when a mouse click occurs */
        
    }
    
    override func keyDown(theEvent: NSEvent) {
        
        gameBoard.anyKeyHit(currentTime)
        
        if(!gameBoard.gameStarted) {
            return;
        }
        
        if let c = theEvent.characters {
            if c.containsString("w") {
                gameBoard.players[0].navigate(PlayerDirection.up)
            } else if c.containsString("a") {
                gameBoard.players[0].navigate(PlayerDirection.left)
            } else if c.containsString("s") {
                gameBoard.players[0].navigate(PlayerDirection.down)
            } else if c.containsString("d") {
                gameBoard.players[0].navigate(PlayerDirection.right)
            }
        }
        
        switch(theEvent.keyCode) {
        case 123:
            gameBoard.players[1].navigate(PlayerDirection.left)
        case 124:
            gameBoard.players[1].navigate(PlayerDirection.right)
        case 125:
            gameBoard.players[1].navigate(PlayerDirection.down)
        case 126:
            gameBoard.players[1].navigate(PlayerDirection.up)
        default:
            break
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        self.currentTime = currentTime;
        if(currentTime > lastStepTime + GameScene.stepTime) {
            lastStepTime = currentTime
            gameBoard.update(currentTime)
        }
    }
}
