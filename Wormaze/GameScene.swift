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

class GameScene: SKScene, GameBoardDelegate, GameOverNodeDelegate, PrepareGameNodeDelegate {
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
        self.backgroundColor = SKColor(SRGBRed: 0.8, green: 0.5, blue: 0.0, alpha: 1.0)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        
        self.addChild(gameBoard)
        gameBoard.initialize(CGSize(width: self.size.width - 15, height: self.size.height - 15))
        gameBoard.delegate = self
    
        
        gameBoard.position = CGPoint(x: -gameBoard.size.width / 2.0, y: -gameBoard.size.height / 2.0);
        
        self.prepareGameNode = PrepareGameNode(size: CGSize(width: 400, height: 300), color: SKColor.blueColor())
        self.addChild(self.prepareGameNode!)
        self.prepareGameNode!.initialize()
        self.prepareGameNode!.delegate = self
    }
    
    override func mouseDown(theEvent: NSEvent) {
        /* Called when a mouse click occurs */
        
    }
    
    override func keyDown(theEvent: NSEvent) {
        
        if(gameState == .PrepareGame) {
            if(theEvent.keyCode == 0x24) {
                self.prepareGameNode?.enterPressed()
            }
            if theEvent.modifierFlags.contains(NSEventModifierFlags.NumericPadKeyMask) {
                if let theArrow = theEvent.charactersIgnoringModifiers, keyChar = theArrow.unicodeScalars.first?.value{
                    switch Int(keyChar){
                    case NSUpArrowFunctionKey:
                        self.prepareGameNode?.arrowKeyPressed()
                    case NSDownArrowFunctionKey:
                        self.prepareGameNode?.arrowKeyPressed()
                    case NSRightArrowFunctionKey:
                        self.prepareGameNode?.arrowKeyPressed()
                    case NSLeftArrowFunctionKey:
                        self.prepareGameNode?.arrowKeyPressed()
                    default:
                        break
                    }
                }
            }
            
            if let c = theEvent.characters {
                if c.containsString("w") {
                    self.prepareGameNode?.wasdPressed()
                } else if c.containsString("a") {
                    self.prepareGameNode?.wasdPressed()
                } else if c.containsString("s") {
                    self.prepareGameNode?.wasdPressed()
                } else if c.containsString("d") {
                    self.prepareGameNode?.wasdPressed()
                }
            }
        } else if(gameState == .GameOver) {
            if(theEvent.keyCode == 0x24) {
                gameOverNode?.acceptItem()
            }
            
            if theEvent.modifierFlags.contains(NSEventModifierFlags.NumericPadKeyMask) {
                if let theArrow = theEvent.charactersIgnoringModifiers, keyChar = theArrow.unicodeScalars.first?.value{
                    switch Int(keyChar){
                    case NSUpArrowFunctionKey:
                        gameOverNode?.selectPreviousItem()
                    case NSDownArrowFunctionKey:
                        gameOverNode?.selectNextItem()
                    case NSRightArrowFunctionKey:
                        gameOverNode?.selectNextItem()
                    case NSLeftArrowFunctionKey:
                        gameOverNode?.selectPreviousItem()
                    default:
                        break
                    }
                }
            }
        } else if(gameState == .RunningGame) {
            if(!gameBoard.gameStarted) {
                return;
            }
            
            if(gameBoard.player1 != nil) {
                if let c = theEvent.characters {
                    if c.containsString("w") {
                        gameBoard.player1?.navigate(PlayerDirection.up)
                    } else if c.containsString("a") {
                        gameBoard.player1?.navigate(PlayerDirection.left)
                    } else if c.containsString("s") {
                        gameBoard.player1?.navigate(PlayerDirection.down)
                    } else if c.containsString("d") {
                        gameBoard.player1?.navigate(PlayerDirection.right)
                    }
                }
            }
            
            if(gameBoard.player2 != nil) {
                switch(theEvent.keyCode) {
                case 123:
                    gameBoard.player2?.navigate(PlayerDirection.left)
                case 124:
                    gameBoard.player2?.navigate(PlayerDirection.right)
                case 125:
                    gameBoard.player2?.navigate(PlayerDirection.down)
                case 126:
                    gameBoard.player2?.navigate(PlayerDirection.up)
                default:
                    break
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {        
        self.currentTime = currentTime;
        if(currentTime > lastStepTime + GameScene.stepTime) {
            lastStepTime = currentTime
            gameBoard.updateStep(currentTime)
            CGDisplayHideCursor(0)
        }
    }
    
    func gameBoardGameOver() {
        gameOverNode = GameOverNode(delegate: self)
        self.addChild(gameOverNode!)
        gameOverNode!.initialize()
        self.gameState = .GameOver
    }
    
    func gameOverNodeDidContinue() {
        self.gameBoard.newGame()
        self.gameOverNode?.removeFromParent()
        self.gameOverNode = nil
        self.prepareGameNode = PrepareGameNode(size: CGSize(width: 400, height: 300), color: SKColor.blueColor())
        self.addChild(self.prepareGameNode!)
        self.prepareGameNode!.initialize()
        self.prepareGameNode!.delegate = self
        self.gameState = .PrepareGame
    }
    
    func gameOverNodeDidCancel() {
        self.gameSceneDelegate?.gameSceneDidCancel()
    }
    
    func prepareGameNodeAddedPlayer(id: Int) {
        self.gameBoard.addPlayer(id)
    }
    
    func prepareGameNodeDidContinue() {
        self.gameBoard.startGame()
        self.gameState = .RunningGame
        self.prepareGameNode?.removeFromParent()
    }
}
