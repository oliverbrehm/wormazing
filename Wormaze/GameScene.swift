//
//  GameScene.swift
//  Wormaze
//
//  Created by Oliver Brehm on 25.12.15.
//  Copyright (c) 2015 Oliver Brehm. All rights reserved.
//

import SpriteKit

struct GameSceneZ
{
    let Background = CGFloat(0)
    let Player = CGFloat(1)
    let Menu = CGFloat(2)
}

protocol GameSceneDelegate
{
    func gameSceneDidCancel()
}

enum GameState
{
    case PrepareGame
    case RunningGame
    case GameOver
}

class GameScene: SKScene, GameBoardDelegate, DialogNodeDelegate {
    static let zPositions = GameSceneZ()
    
    var gameState = GameState.PrepareGame
    
    static let stepTime: CFTimeInterval = 0.1
    
    var lastStepTime: CFTimeInterval = 0;
    var currentTime: CFTimeInterval = 0;
    
    let gameBoard = GameBoard()
    
    var gameOverNode: GameOverNode?
    var prepareGameNode: PrepareGameNode?
    
    var gameSceneDelegate: GameSceneDelegate?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = SKColor(red: 0.8, green: 0.5, blue: 0.0, alpha: 1.0)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        
        self.addChild(gameBoard)
        gameBoard.initialize(CGSize(width: self.size.width - 15, height: self.size.height - 15))
        gameBoard.delegate = self
    
        
        gameBoard.position = CGPoint(x: -gameBoard.size.width / 2.0, y: -gameBoard.size.height / 2.0);
        
        self.prepareGameNode = PrepareGameNode(size: CGSize(width: self.size.width, height: self.size.height), color: SKColor(white: 1.0, alpha: 0.3))
        self.addChild(self.prepareGameNode!)
        self.prepareGameNode!.initialize()
        self.prepareGameNode!.delegate = self
        
        if let view = self.view as? GameView {
            view.primaryController()?.removeControl()
        }
    }
    
    func addGameController(controller: GameController)
    {
        if(self.gameState == .PrepareGame) {
            let player = self.gameBoard.addPlayer()
            controller.assignPlayer(player)
            controller.assignDialog(self.prepareGameNode)
            
            if(controller.name == "wasdController") {
                self.prepareGameNode?.wasdPressed(player!.color)
            } else if(controller.name == "arrowKeysController") {
                self.prepareGameNode?.arrowKeyPressed(player!.color)
            } else if(controller.name == "hbnmController") {
                self.prepareGameNode?.hbnmPressed(player!.color)
            } else if(controller.name == "siriRemoteController") {
                self.prepareGameNode?.remoteAdded(player!.color)
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {        
        self.currentTime = currentTime;
                
        if(currentTime > lastStepTime + GameScene.stepTime) {
            lastStepTime = currentTime
            gameBoard.updateStep(currentTime)
        }
    }
    
    func dialogDidAcceptItem(dialog: DialogNode, item: MenuItem?) {
        if(item != nil && dialog === self.gameOverNode) {
            if(item!.name == "playAgain") {
                self.gameOverNodeDidContinue()
            } else if(item!.name == "toMenu") {
                self.gameOverNodeDidCancel()
            }
        } else if(dialog === self.prepareGameNode && self.prepareGameNode!.playerJoined) {
            self.prepareGameNodeDidContinue()
        }
    }
    
    func gameBoardGameOver() {
        gameOverNode = GameOverNode()
        self.gameOverNode!.size = self.size
        self.gameOverNode!.delegate = self
        self.addChild(gameOverNode!)
        gameOverNode!.initialize()
        self.gameState = .GameOver
        
        if let view = self.view as? GameView {
            for controller in view.gameControllers {
                controller.assignDialog(self.gameOverNode)
            }
        }
    }
    
    func gameOverNodeDidContinue() {
        self.gameBoard.newGame()
        self.gameOverNode?.removeFromParent()
        self.gameOverNode = nil
        self.prepareGameNode = PrepareGameNode(size: CGSize(width: self.size.width, height: self.size.height), color: SKColor(white: 1.0, alpha: 0.3))
        self.addChild(self.prepareGameNode!)
        self.prepareGameNode!.initialize()
        self.prepareGameNode!.delegate = self
        self.gameState = .PrepareGame
        
        if let view = self.view as? GameView {
            for controller in view.gameControllers {
                controller.removeControl()
            }
        }
    }
    
    func gameOverNodeDidCancel() {
        self.gameSceneDelegate?.gameSceneDidCancel()
    }
    
    func prepareGameNodeDidContinue() {
        self.gameBoard.startGame()
        self.gameState = .RunningGame
        self.prepareGameNode?.removeFromParent()
    }
    

}
