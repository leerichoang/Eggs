//
//  GameScene.swift
//  Eggs2.0
//
//  Created by Gary Chan on 3/10/19.
//  Copyright © 2019 Rickster Software. All rights reserved.
//

import SpriteKit
import GameplayKit

var scoreNum = 0
class GameScene: SKScene, SKPhysicsContactDelegate {
    let bgMusic = SKAudioNode(fileNamed: "BGM.wav")
    
    // Sound Declartions
    let hit1 = SKAction.playSoundFileNamed("EggHit1.wav", waitForCompletion: false)
    let hit2 = SKAction.playSoundFileNamed("EggHit2.wav", waitForCompletion: false)
    let hit3 = SKAction.playSoundFileNamed("EggHit3.wav", waitForCompletion: false)

    let scoreLabel = SKLabelNode(fontNamed: "Helvetica")
    let healthLable = SKLabelNode(fontNamed: "Helvetica")
    let levelLable = SKLabelNode(fontNamed: "Splatch")
    
    var eggsBroken: Int = 0
    var eggsAmount: Int = 25
    var level: Int = 1
    var eggSpeed: Double = 5
    var eggCombo: Int = 1
    var healthBar: Int = 100
    let gameArea: CGRect
    
            let player = SKSpriteNode(imageNamed: "Player")
    struct PhysicsCategories{
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1 //1
        static let Rock: UInt32 = 0b10 //2
        static let Egg: UInt32 = 0b100 // 4
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
   
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        // To check for numerical order.
        if contact.bodyA.categoryBitMask < contact.bodyB.contactTestBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Egg{
            // Player hits egg
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            runGameOver()
        }
        if body1.categoryBitMask == PhysicsCategories.Rock && body2.categoryBitMask == PhysicsCategories.Egg{
            // Rock hits egg
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            spawnNewEgg()
            eggsBroken += 1
            scoreNum += level
            
            eggCombo += 1
            
            healthBar += eggCombo
            
            if healthBar >= 100{
                healthBar = 100
            }
            healthLable.text = "Health:\(healthBar)"
            
        
        scoreLabel.text = "\(scoreNum)"
        if eggsBroken % 15 == 10 && eggSpeed >= 2.5{
            eggSpeed -= 0.3
            level += 1
            
        }
        
        if eggsBroken % eggsAmount == eggsAmount-1
        {
            eggsAmount += 20
            spawnNewEgg()
            level += 1
        }
        
        levelLable.text = "Level:\(level)"
            
        }
    }
    override init(size: CGSize)
    {
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height/maxAspectRatio
        let gameAreaMargin = (size.width - playableWidth)/2
        gameArea = CGRect(x: gameAreaMargin, y: 0, width: playableWidth, height:size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder:) has not been impletmented")
    }
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random())/0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    override func didMove(to view: SKView) {
        
        self.addChild(bgMusic)
        self.physicsWorld.contactDelegate = self as SKPhysicsContactDelegate
        scoreNum = 0
        let background = SKSpriteNode(imageNamed: "Grass")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2 ,y: self.size.height/2 )
        // to center on screen
        background.zPosition = 0
        self.addChild(background)
        

        player.setScale(1)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Egg
        self.addChild(player)
        
        spawnNewEgg()
        
        //LABELS
        scoreLabel.fontSize = 250
        scoreLabel.text = "0"
        scoreLabel.fontColor = SKColor.white
        scoreLabel.zPosition = 1
        scoreLabel.position = CGPoint(x:self.size.width/2, y: self.size.height*0.85)
        self.addChild(scoreLabel)
        
        levelLable.fontSize = 50
        levelLable.text = "Level:1"
        levelLable.fontColor = SKColor.white
        levelLable.zPosition = 1
        levelLable.position = CGPoint(x:self.size.width*0.35, y: self.size.height*0.95)
        self.addChild(levelLable)
        
        healthLable.fontSize = 100
        healthLable.text = "Health:100"
        healthLable.fontColor = SKColor.green
        healthLable.zPosition = 1
        healthLable.position = CGPoint(x: self.size.width*0.35, y: self.size.height*0.05)
        self.addChild(healthLable)
        
    }
    
    
    func spawnNewEgg(){
        
        var randomImageNumber = arc4random()%2
        randomImageNumber += 1
        
        let egg = SKSpriteNode(imageNamed: "Egg\(randomImageNumber)")
        let eggTrait = Int.random(in: 5 ... 10)
        egg.size = CGSize(width: egg.size.width*CGFloat(eggTrait) , height: egg.size.height*CGFloat(eggTrait))
        egg.zPosition = 2
        egg.physicsBody = SKPhysicsBody(rectangleOf: egg.size)
        egg.physicsBody!.affectedByGravity = false
        egg.physicsBody!.categoryBitMask = PhysicsCategories.Egg
        egg.physicsBody!.collisionBitMask = PhysicsCategories.None
        egg.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Rock

        egg.name = "eggObject"
        
        let randomX = random(min: gameArea.minX + egg.size.width/2,
                             max: gameArea.maxX - egg.size.width/2)
        
        egg.position = CGPoint(x: randomX, y: (gameArea.maxY - egg.size.height/2))
        self.addChild(egg)
        let randomXdrop = random(min: gameArea.minX + egg.size.width/2,
                                 max: gameArea.maxX - egg.size.width/2)
        
        func loseHealth()
        {
            
            healthBar -= 5
            healthBar -= eggTrait
            let randSound = Int.random(in: 1 ... 3)
            switch randSound {
            case 2:
                            self.run(hit2)
            case 3:
                            self.run(hit3)
            default:
                            self.run(hit1)
            }

            eggCombo = 1
            healthLable.text = "Health:\(healthBar)"
            if healthBar >= 70{
                healthLable.fontColor = SKColor.green
            }
            if healthBar < 70{
                healthLable.fontColor = SKColor.yellow
            }
            if healthBar < 50{
                healthLable.fontColor = SKColor.orange
            }
            if healthBar < 30{
                healthLable.fontColor = SKColor.red
            }
            if healthBar <= 0
            {
                runGameOver()
                bgMusic.run(SKAction.stop())
            }
        }
        

        egg.run(SKAction.rotate(byAngle: 45, duration: 6))
        egg.run(SKAction.sequence([
            SKAction.move(to: CGPoint(x: randomXdrop ,y:0), duration: eggSpeed),
            SKAction.run(loseHealth), SKAction.run(spawnNewEgg), SKAction.removeFromParent()
            ]))
    }
    
   
    func runGameOver(){
        // End game code
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        // passing same size and scale mode so they look simular
        let sceneTransition = SKTransition.fade(withDuration: 0.2)
        //view is what presents scene
        self.view!.presentScene(sceneToMoveTo, transition: sceneTransition)
        
    
    }
    
    func fireShot(){
        let rock = SKSpriteNode(imageNamed: "Rock")
        rock.setScale(1)
        rock.position = player.position
        rock.zPosition = 1
        rock.physicsBody = SKPhysicsBody(rectangleOf: rock.size)
        rock.physicsBody!.affectedByGravity = false
        rock.physicsBody!.categoryBitMask = PhysicsCategories.Rock
        rock.physicsBody!.collisionBitMask = PhysicsCategories.None
        rock.physicsBody!.contactTestBitMask = PhysicsCategories.Egg

        self.addChild(rock)

        let moveRock = SKAction.moveTo(y: gameArea.maxY, duration: 1)
        let deleteRock = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([moveRock,deleteRock])
        rock.run(bulletSequence)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointofTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointofTouch.x-previousPointOfTouch.x
            
            player.position.x += amountDragged
            
            if(player.position.x > self.gameArea.maxX-player.size.width/2) {
                player.position.x = self.gameArea.maxX-player.size.width/2
            }
            if(player.position.x < self.gameArea.minX+player.size.width/2) {
                player.position.x = self.gameArea.minX+player.size.width/2
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
                        fireShot()
            }
        }
    
    }
 

