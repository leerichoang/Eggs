//
//  MainMenuScene.swift
//  Eggs2.0
//
//  Created by Gary Chan on 3/10/19.
//  Copyright © 2019 Rickster Software. All rights reserved.
//

import Foundation
import SpriteKit


class MainMenuScene: SKScene{
    let defaults = UserDefaults()
    let clickSound = SKAction.playSoundFileNamed("click.wav", waitForCompletion: false)

    let highScoreLabel = SKLabelNode(fontNamed: "Splatch")

    override func didMove(to view: SKView) {
        
        let highScoreNumber = defaults.integer(forKey: "highScoreSaved")


        let background = SKSpriteNode(imageNamed: "Grass")
        background.size = self.size
        background.zPosition = 0
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(background)
        
        let gameTitleLabel1 = SKLabelNode()
        gameTitleLabel1.fontName = "Splatch"
        gameTitleLabel1.text = "EGGS"
        gameTitleLabel1.fontSize = 250
        gameTitleLabel1.fontColor = SKColor.white
        gameTitleLabel1.position = CGPoint(x: self.size.width/2, y: self.size.height*0.6)
        gameTitleLabel1.zPosition = 1
        self.addChild(gameTitleLabel1)
        

        highScoreLabel.text = "High Score : \(highScoreNumber)"
        highScoreLabel.fontSize = 140
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.zPosition = 1
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.8)
        self.addChild(highScoreLabel)
        
        let authorTitleLabel = SKLabelNode(fontNamed: "Splatch.ttf")
        authorTitleLabel.text = "By Ricster Software"
        authorTitleLabel.fontSize = 50
        authorTitleLabel.fontColor = SKColor.white
        authorTitleLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.95)
        authorTitleLabel.zPosition = 1
        self.addChild(authorTitleLabel)

        let gameTutorial = SKLabelNode(fontNamed: "Splatch")
        gameTutorial.text = "Protect your House!"
        gameTutorial.fontSize = 75
        gameTutorial.fontColor = SKColor.white
        gameTutorial.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        gameTutorial.zPosition = 1
        self.addChild(gameTutorial)
        
        let startLabel = SKLabelNode(fontNamed: "Splatch")
        startLabel.text = "Play"
        startLabel.fontSize = 200
        startLabel.fontColor = SKColor.white
        startLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.40)
        startLabel.zPosition = 1
        startLabel.name = "startButton"
        self.addChild(startLabel)
        
        let resetLabel = SKLabelNode(fontNamed: "Splatch")
        resetLabel.text = "Reset HighScore"
        resetLabel.fontSize = 100
        resetLabel.fontColor = SKColor.white
        resetLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/5)
        resetLabel.zPosition = 1
        resetLabel.name = "resetButton"
        self.addChild(resetLabel)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOnTouch = touch.location(in: self)
            let tappedNode = atPoint(pointOnTouch)
            let tappedNodeName = tappedNode.name
            
            if tappedNodeName == "startButton"{
                self.run(clickSound)
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let sceneTransition = SKTransition.fade(withDuration: 0.2)
                self.view!.presentScene(sceneToMoveTo, transition: sceneTransition)
            }
            if tappedNodeName == "resetButton"{
                self.run(clickSound)
                let highScoreNumber = 0
                defaults.set(0, forKey: "highScoreSaved")
                highScoreLabel.text = "High Score : \(highScoreNumber)"
            }
        }
    }
    
}
