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
    let GameboardOverlay = CGFloat(2)
    let Menu = CGFloat(3)
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
    
    var gameBoard: GameBoard = GameBoard()
    
    var gameOverNode: GameOverNode?
    var prepareGameNode: PrepareGameNode?
    var pauseNode: PauseMenuNode?
    
    let consumablesNode = PlayerConsumablesNode()
    
    static let gameCost = 10
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = SKColor(red: 0.4, green: 0.3, blue: 0.3, alpha: 1.0)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        
        if(self.children.count <= 0) {
            if(gameMode == .singleplayer) {
                self.gameBoard = SingleplayerGame()
            } else {
                self.gameBoard = MultiplayerGame()
            }
            
            self.addChild(gameBoard)
            gameBoard.initialize(self, size: CGSize(width: self.size.width - 20, height: self.size.height - 40))
            gameBoard.delegate = self
            
            gameBoard.position = CGPoint(x: -gameBoard.size.width / 2.0, y: -gameBoard.size.height / 2.0 - 10.0);
            
            consumablesNode.position = CGPoint(x: -self.size.width / 2.0 + 5.0, y: self.size.height / 2.0 - 5.0)
            self.addChild(consumablesNode)
            consumablesNode.initialize()
            
            self.prepareGameNode = PrepareGameNode(size: CGSize(width: self.size.width, height: self.size.height), color: SKColor(white: 1.0, alpha: 0.5), name: "GameOverNode")
            self.addChild(self.prepareGameNode!)
            self.prepareGameNode!.initialize(self.gameMode)
            self.prepareGameNode!.delegate = self
            
            (self.view as! GameView).removeAllControls()            
        }
        
        if let view = self.view as? GameView {
            if(self.gameOverNode != nil) {
                for controller in view.gameControllers {
                    controller.assignDialog(self.gameOverNode)
                }
            } else {
                for controller in view.gameControllers {
                    controller.assignDialog(self.prepareGameNode)
                }
            }
        }
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
            } else if(controller.name == "touchController") {
                self.prepareGameNode?.touchControllerAdded(player!.color)
            } else if(controller.name == "gameController") {
                self.prepareGameNode?.gameControllerAdded(player!.color)
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
            } else if(item!.name == "buyExtralife") {
                if(!GameView.instance!.buyExtralife()) {
                    GameView.instance!.displayShopScene()
                } else {
                    self.consumablesNode.update()
                }
            } else if(item!.name == "shop") {
                GameView.instance!.displayShopScene()
            }
        } else if(dialog === self.prepareGameNode && item != nil) {
            if(item!.name == "startGame") {
                self.prepareGameNodeDidContinue()
            } else if(item!.name == "toMenu") {
                self.toMenu()
            }
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
                view.gameKitManager!.reportSingleplayerHighscore(score!, completion: {
                    if(self.gameOverNode != nil) {
                        (self.gameOverNode!.itemForName("leaderboard") as? LeaderboardNode)?.initialize()
                    }
                })
            }
        }
        
        // delay menu controls because player probably was in panic
        self.runAction(SKAction.waitForDuration(1)) { () -> Void in
            if let view = self.view as? GameView {
                for controller in view.gameControllers {
                    controller.assignDialog(self.gameOverNode)
                }
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
        GameView.instance?.serializeUserData()
    
        (self.view as! GameView).removeAllControls()
        
        GameView.instance!.gameSceneDidCancel()
    }
    
    func prepareGameNodeDidContinue() {
        if(gameMode == GameMode.multiplayer) {
            if(GameView.instance!.coins >= 10) {
                GameView.instance!.coins -= 10
                GameView.instance!.serializeUserData()
                self.startGame()
            } else {
                GameView.instance!.displayShopScene()
            }
        } else {
            self.startGame()
        }
    }

    func startGame() {
        self.gameBoard.startGame()
        self.gameState = .RunningGame
        self.prepareGameNode?.removeFromParent()
        self.prepareGameNode =  nil
        self.consumablesNode.update()
    }
}
