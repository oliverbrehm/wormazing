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

class GameScene: SKScene, GameBoardDelegate, GameOverNodeDelegate, PrepareGameNodeDelegate, GameControllerDelegate {
    static let zPositions = GameSceneZ()
    
    var gameState = GameState.PrepareGame
    
    static let stepTime: CFTimeInterval = 0.1
    
    var lastStepTime: CFTimeInterval = 0;
    var currentTime: CFTimeInterval = 0;
    
    let gameBoard = GameBoard()
    
    var gameOverNode: GameOverNode?
    var prepareGameNode: PrepareGameNode?
    
    var gameSceneDelegate: GameSceneDelegate?
    
    let wasdController = GameController()
    let hbnmController = GameController()
    let arrowController = GameController()
    let remotControl = GameController()
    
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
        
        self.wasdController.delegate = self
        self.hbnmController.delegate = self
        self.arrowController.delegate = self
        self.remotControl.delegate = self
    }
    

    
    override func update(currentTime: CFTimeInterval) {        
        self.currentTime = currentTime;
                
        if(currentTime > lastStepTime + GameScene.stepTime) {
            lastStepTime = currentTime
            gameBoard.updateStep(currentTime)
            // TODO
            //CGDisplayHideCursor(0)
        }
    }
    
    func gameBoardGameOver() {
        gameOverNode = GameOverNode(delegate: self)
        self.gameOverNode?.size = self.size
        self.addChild(gameOverNode!)
        gameOverNode!.initialize()
        self.gameState = .GameOver
        
        self.wasdController.assignDialog(self.gameOverNode)
        self.arrowController.assignDialog(self.gameOverNode)
        self.hbnmController.assignDialog(self.gameOverNode)
        self.remotControl.assignDialog(self.gameOverNode)
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
        
        self.wasdController.removeControl()
        self.hbnmController.removeControl()
        self.arrowController.removeControl()
        self.remotControl.removeControl()
    }
    
    func gameOverNodeDidCancel() {
        self.gameSceneDelegate?.gameSceneDidCancel()
    }
    
    func prepareGameNodeDidContinue() {
        self.gameBoard.startGame()
        self.gameState = .RunningGame
        self.prepareGameNode?.removeFromParent()
    }
    
    func gameControllerNotAssigned(controller: GameController) {
        if(self.gameState == .PrepareGame) {
            let player = self.gameBoard.addPlayer()
            controller.assignPlayer(player)
            
            if(controller === wasdController) {
                self.prepareGameNode?.wasdPressed(player!.color)
            } else if(controller === arrowController) {
                self.prepareGameNode?.arrowKeyPressed(player!.color)
            } else if(controller === hbnmController) {
                self.prepareGameNode?.hbnmPressed(player!.color)
            } else if(controller === remotControl) {
                self.prepareGameNode?.remoteAdded(player!.color)
            }
        }
    }
}
