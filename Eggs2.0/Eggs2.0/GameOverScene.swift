//
//  GameOverScene.swift
//  Eggs2.0
//
//  Created by Gary Chan on 3/10/19.
//  Copyright © 2019 Rickster Software. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
        let clickSound = SKAction.playSoundFileNamed("click.wav", waitForCompletion: false)
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "Grass")
        background.size = self.size
        background.zPosition = 0
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(background)
        
        let gameOverLabel = SKLabelNode(fontNamed: "Splatch")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 200
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.75)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        let finalScoreLabel = SKLabelNode()
        finalScoreLabel.text = "Score: \(scoreNum)"
        finalScoreLabel.fontSize = 140
        finalScoreLabel.position = CGPoint(x: self.size.width/2 , y: self.size.height*0.6)
        finalScoreLabel.color = SKColor.red
        self.addChild(finalScoreLabel)
        
        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if scoreNum > highScoreNumber{
            highScoreNumber = scoreNum
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }
        
        let highScoreLabel = SKLabelNode()
        highScoreLabel.text = "High Score : \(highScoreNumber)"
        highScoreLabel.fontSize = 140
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.zPosition = 1
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(highScoreLabel)
        
        
        let restartLabel = SKLabelNode()
        restartLabel.text = "Restart"
        restartLabel.fontSize = 140
        restartLabel.fontColor = SKColor.cyan
        restartLabel.position = CGPoint(x:self.size.width/2, y: self.size.height*0.3)
        restartLabel.zPosition = 1
        restartLabel.name = "restartButton"
        self.addChild(restartLabel)
        
        let exitLabel = SKLabelNode()
        exitLabel.text = "Exit"
        exitLabel.fontSize = 140
        exitLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.2 )
        exitLabel.zPosition = 1
        exitLabel.name = "exitButton"
        self.addChild(exitLabel)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let tappedNode = atPoint(pointOfTouch)
            let tappedNodeName = tappedNode.name
            
            if tappedNodeName == "restartButton"{
                self.run(clickSound)
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let sceneTransition = SKTransition.fade(withDuration: 0.2)
                self.view!.presentScene(sceneToMoveTo, transition: sceneTransition)
            }
            if tappedNodeName == "exitButton"{
                self.run(clickSound)
                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let sceneTransition = SKTransition.fade(withDuration: 0.2)
                self.view!.presentScene(sceneToMoveTo, transition: sceneTransition)
            }
        }
    }
    
}
