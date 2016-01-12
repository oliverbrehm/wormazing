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

class PlayerColors
{
    let colors: [SKColor]
    let colorNames: [String]
    
    init()
    {
        self.colors = [SKColor.redColor(), SKColor.blueColor(), SKColor.greenColor(), SKColor.orangeColor()]
        self.colorNames = ["Red", "Blue", "Green", "Orange"]
    }
    
    func colorForPlayer(id: Int) -> SKColor?
    {
        if(id < 0 || id >= colors.count) {
            return nil
        }
        
        return colors[id]
    }
    
    func colorNameForPlayer(id: Int) -> String?
    {
        if(id < 0 || id >= colorNames.count) {
            return nil
        }
        
        return colorNames[id]
    }
    
    func colorNameForPlayer(player: Player) -> String?
    {
        return self.colorNameForPlayer(player.id)
    }
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
    case Paused
}

enum GameMode
{
    case singleplayer, multiplayer
}

class GameScene: SKScene, GameBoardDelegate, DialogNodeDelegate {
    static let zPositions = GameSceneZ()
    static let playerColors = PlayerColors()
    
    var gameState = GameState.PrepareGame
    var gameMode = GameMode.singleplayer
    
    var gameBoard = GameBoard()
    
    var gameOverNode: GameOverNode?
    var prepareGameNode: PrepareGameNode?
    var pauseNode: PauseMenuNode?
    
    var gameSceneDelegate: GameSceneDelegate?
    
    let debugLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = SKColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        
        self.debugLabel.text = ""
        self.debugLabel.fontSize = 14.0
        self.debugLabel.position = CGPoint(x: 200.0, y: -self.size.height / 2.0 + 7.0)
        self.addChild(self.debugLabel)
        
        if(gameMode == .singleplayer) {
            self.gameBoard = SingleplayerGame()
        } else {
            self.gameBoard = MultiplayerGame()
        }
        
        self.addChild(gameBoard)
        gameBoard.initialize(CGSize(width: self.size.width - 20, height: self.size.height - 60))
        gameBoard.delegate = self
    
        gameBoard.position = CGPoint(x: -gameBoard.size.width / 2.0, y: -gameBoard.size.height / 2.0);
        
        self.prepareGameNode = PrepareGameNode(size: CGSize(width: self.size.width, height: self.size.height), color: SKColor(white: 1.0, alpha: 0.5), name: "GameOverNode")
        self.addChild(self.prepareGameNode!)
        self.prepareGameNode!.initialize(self.gameMode)
        self.prepareGameNode!.delegate = self
        
        (self.view as! GameView).removeAllControls()
        
        if let view = self.view as? GameView {
            for controller in view.gameControllers {
                controller.assignDialog(self.prepareGameNode)
            }
        }
    }
    
    func debug(message: String)
    {
        self.debugLabel.text = "DEBUG: " + message
    }
    
    func addGameController(controller: Controller)
    {
        if(self.gameMode == .singleplayer && self.gameBoard.players.count >= 1) {
            return
        }
    
        if(self.gameState == .PrepareGame) {
            let player = self.gameBoard.addPlayer()
            controller.assignPlayer(player)
            
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
        gameBoard.update(currentTime)
    }
    
    func dialogDidAcceptItem(dialog: DialogNode, item: MenuItem?) {
        if(item != nil && dialog === self.gameOverNode) {
            if(item!.name == "playAgain") {
                self.gameOverNodeDidContinue()
            } else if(item!.name == "toMenu") {
                self.toMenu()
            }
        } else if(dialog === self.prepareGameNode && item != nil) {
            self.prepareGameNodeDidContinue()
        } else if(dialog === self.pauseNode && item != nil) {
            if(item!.name == "continue") {
                self.gameState = .RunningGame
                self.gameBoard.resume()
                self.pauseNode!.removeFromParent()
                self.pauseNode = nil
            } else if(item!.name == "toMenu") {
                self.toMenu()
            }
        }
    }
    
    func dialogDidCancel(dialog: DialogNode) {
        if(dialog === self.prepareGameNode) {
            self.toMenu()
        } else if(dialog === self.gameOverNode) {
            self.toMenu()
        }
    }
    
    func gameBoardGameOver(score: Int?, message: String, color: SKColor) {
        gameOverNode = GameOverNode()
        self.gameOverNode!.size = self.size
        self.gameOverNode!.delegate = self
        self.addChild(gameOverNode!)
        gameOverNode!.initialize(message, color: color)
        self.gameState = .GameOver
        
        if let view = (self.view as? GameView) {
            if(view.gameKitManager != nil && score != nil) {
                view.gameKitManager!.reportSingleplayerHighscore(score!)
            }
        }
        
        if let view = self.view as? GameView {
            for controller in view.gameControllers {
                controller.assignDialog(self.gameOverNode)
            }
        }
    }
    
    func gameBoardPaused() {
        pauseNode = PauseMenuNode()
        self.pauseNode!.size = self.size
        self.pauseNode!.delegate = self
        self.addChild(pauseNode!)
        pauseNode!.initialize()
        //self.gameState = .Paused
    
        if let view = self.view as? GameView {
            for controller in view.gameControllers {
                controller.assignDialog(self.pauseNode)
            }
        }
    }
    
    func gameOverNodeDidContinue() {
        self.gameBoard.newGame()
        self.gameOverNode?.removeFromParent()
        self.gameOverNode = nil
        self.prepareGameNode = PrepareGameNode(size: CGSize(width: self.size.width, height: self.size.height), color: SKColor(white: 1.0, alpha: 0.5), name: "GameOverNode")
        self.addChild(self.prepareGameNode!)
        self.prepareGameNode!.initialize(self.gameMode)
        self.prepareGameNode!.delegate = self
        self.gameState = .PrepareGame
        
        (self.view as! GameView).removeAllControls()
        
        if let view = self.view as? GameView {
            for controller in view.gameControllers {
                controller.assignDialog(self.prepareGameNode)
            }
        }
    }
    
    func toMenu() {
        (self.view as! GameView).removeAllControls()
        
        self.gameSceneDelegate?.gameSceneDidCancel()
    }
    
    func prepareGameNodeDidContinue() {
        self.gameBoard.startGame()
        self.gameState = .RunningGame
        self.prepareGameNode?.removeFromParent()
        self.prepareGameNode =  nil
    }
}
