//
//  GameScene.swift
//  TestGame
//
//  Created by Raffaele Siciliano on 07/02/22.
//

import SpriteKit

enum GameState {
    case ready
    case playing
    case dead
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameState = GameState.ready {
        didSet {
            print(gameState)
        }
    }
    
    var scoreText = SKLabelNode()
    var scoreLabel = SKLabelNode()
    var scoreBG = SKSpriteNode()
    
    var score : Int = 0 {
        didSet {
            if score <= 0 {
                score = 0
            }
            scoreText.text = "SCORE"
            scoreLabel.text = "\(score)"
        }
    }
    
    var player = SKSpriteNode()
    
    let perkA = SKTexture(imageNamed: UserDefaults.standard.string(forKey: "textureOne") ?? "Perchy_1")
    let perkB = SKTexture(imageNamed: UserDefaults.standard.string(forKey: "textureTwo") ?? "Perchy_2")
    
    var crowdMatrix : [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "L", "M", "N", "O", "P", "Q", "R", "S"]
    var crowdIndex = 0
    var civilianIndex = 0
    var civilian = SKSpriteNode()
    
    var infectedCivilian = SKSpriteNode()
    var infectedCivTimer = 12.0
    var backgroundCivilian = SKSpriteNode()
    
    var startingCrowd = SKSpriteNode()
    var backgroundStartingCrowd = SKSpriteNode()
    var crowd = SKSpriteNode()
    var backgroundCrowd = SKSpriteNode()
    var assX : Double = 0.0
    var assY : Double = 0.5
    var crowdZ : CGFloat = 3
    
    var potion = SKSpriteNode()
    
    let exp1 = SKTexture(imageNamed: "Infected_effect_0")
    let exp2 = SKTexture(imageNamed: "Infected_effect_1")
    let exp3 = SKTexture(imageNamed: "Infected_effect_2")
    let exp4 = SKTexture(imageNamed: "Infected_effect_3")
    let exp5 = SKTexture(imageNamed: "Infected_effect_4")
    let exp6 = SKTexture(imageNamed: "Infected_effect_5")
    let exp7 = SKTexture(imageNamed: "Infected_effect_6")
    
    let heal1 = SKTexture(imageNamed: "HealEffect1")
    let heal2 = SKTexture(imageNamed: "HealEffect2")
    let heal3 = SKTexture(imageNamed: "HealEffect3")
    let heal4 = SKTexture(imageNamed: "HealEffect4")
    let heal5 = SKTexture(imageNamed: "HealEffect5")
    
    let infectedAnimation1 = SKTexture(imageNamed: "frame_0_delay-0.16s")
    let infectedAnimation2 = SKTexture(imageNamed: "frame_1_delay-0.16s")
    let infectedAnimation3 = SKTexture(imageNamed: "frame_2_delay-0.16s")
    let infectedAnimation4 = SKTexture(imageNamed: "frame_3_delay-0.16s")
    let infectedAnimation5 = SKTexture(imageNamed: "frame_4_delay-0.16s")
    let infectedAnimation6 = SKTexture(imageNamed: "frame_5_delay-0.16s")
    
    let infectedCivilian1 = SKTexture(imageNamed: "frame_0_delay-0.1s")
    let infectedCivilian2 = SKTexture(imageNamed: "frame_1_delay-0.1s")
    let infectedCivilian3 = SKTexture(imageNamed: "frame_2_delay-0.1s")
    let infectedCivilian4 = SKTexture(imageNamed: "frame_3_delay-0.1s")
    let infectedCivilian5 = SKTexture(imageNamed: "frame_4_delay-0.1s")
    let infectedCivilian6 = SKTexture(imageNamed: "frame_5_delay-0.1s")
    
    weak var sceneDelegate: GameSceneDelegate?
    
    let pause = SKSpriteNode(imageNamed: "pauseButton")
    
    var barra = SKSpriteNode()
    var barraExit = SKSpriteNode()
    var barradietro = SKSpriteNode()
    var buttonresume = SKSpriteNode()
    var retryButton = SKSpriteNode()
    var exitButton = SKSpriteNode()
    
    var exitLabel = SKSpriteNode()
    var exitYes = SKSpriteNode()
    var exitNo = SKSpriteNode()
    
    var musicLevel = SKAudioNode()
    var soundEffectLevel = SKAudioNode()
    
    var gameOverBG = SKSpriteNode()
    var actualScoreLabel = SKLabelNode()
    var bestScoreLabel = SKLabelNode()
    var actualScoreBG = SKSpriteNode()
    var bestScoreBG = SKSpriteNode()
    var gameOverRetry = SKSpriteNode()
    
    var civilianSpeed : CGFloat = 2.3
    var pointsMultiplier : Int = 1
    
    var powerActivate = SKSpriteNode()
    var powerIndex = 0
    
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func moveBackground(image: [String], x: CGFloat, z:CGFloat, duration: Double, size: CGSize) {
        for i in 0...9 {
            
            let background = SKSpriteNode(imageNamed: image[i])
            background.anchorPoint = CGPoint.zero
            background.size = size
            background.position = CGPoint(x: x, y: size.height * CGFloat(i))
            background.zPosition = z
            
            let move = SKAction.moveBy(x: 0, y: -background.size.height*9, duration: 0)
            let back = SKAction.moveBy(x: 0, y: background.size.height*9, duration: duration)
            
            let sequence = SKAction.sequence([move, back])
            let repeatAction = SKAction.repeatForever(sequence)
            
            addChild(background)
            background.run(repeatAction)
            
        }
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "Perchiazzetto_0")
        
        player.position = CGPoint(x: frame.midX, y: frame.midY)
        player.zPosition = Layer.player
        player.size = CGSize(width: Size.characterWidth, height: Size.characterHeight)
        
        player.name = "player"
        let animation = SKAction.animate(with: [perkA, perkB], timePerFrame:0.2)
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.crowd | PhysicsCategory.infectedCivilian
        player.physicsBody?.collisionBitMask = PhysicsCategory.crowd | PhysicsCategory.infectedCivilian
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = true
        
        addChild(player)
        player.run(SKAction.repeatForever(animation))
        
    }
    
    func createCivilian() {
        
        speedUpCivilian()
        print(civilianIndex)
        
        civilian = SKSpriteNode(imageNamed: "Character_" + crowdMatrix[civilianIndex] + "_0")
        civilian.position = CGPoint(x: random(min: frame.midX/2, max: frame.midX + (frame.midX/2)), y: frame.minY)
        civilian.zPosition = crowdZ
        civilian.size = CGSize(width: Size.characterWidth, height: Size.characterHeight)
        civilian.name = "civilian"
        
        civilian.physicsBody = SKPhysicsBody(rectangleOf: civilian.size)
        civilian.physicsBody?.categoryBitMask = PhysicsCategory.civilian
        civilian.physicsBody?.contactTestBitMask = PhysicsCategory.crowd
        civilian.physicsBody?.collisionBitMask = PhysicsCategory.crowd
        civilian.physicsBody?.affectedByGravity = false
        civilian.physicsBody?.isDynamic = true
        
        civilian.run(SKAction.moveBy(x: 0.0, y: frame.size.height + civilian.size.height, duration: TimeInterval(civilianSpeed)))
        
        addChild(civilian)
    }
    
    func createInfectedCivilian() {
        
        speedUpCivilian()
        print(civilianIndex)
        var infectedIndex = 0
        if civilianIndex == 0 {
            infectedIndex = civilianIndex + 3
        } else {
            infectedIndex = civilianIndex - 1
        }
        
        infectedCivilian = SKSpriteNode(imageNamed: "Character_" + crowdMatrix[infectedIndex] + "_0")
        infectedCivilian.position = CGPoint(x: random(min: frame.midX/2, max: frame.midX + (frame.midX/2)), y: frame.minY)
        infectedCivilian.zPosition = Layer.civilian
        infectedCivilian.size = CGSize(width: Size.characterWidth, height: Size.characterHeight)
        infectedCivilian.name = "infectedCivilian"
        
        infectedCivilian.physicsBody = SKPhysicsBody(rectangleOf: player.size)

        infectedCivilian.physicsBody?.categoryBitMask = PhysicsCategory.infectedCivilian
        infectedCivilian.physicsBody?.contactTestBitMask = PhysicsCategory.player
        infectedCivilian.physicsBody?.collisionBitMask = PhysicsCategory.player
        infectedCivilian.physicsBody?.affectedByGravity = false
        infectedCivilian.physicsBody?.isDynamic = true

        
        addChild(infectedCivilian)
        
        infectedCivilian.run(SKAction.moveBy(x: 0.0, y: frame.size.height + infectedCivilian.size.height, duration: TimeInterval(civilianSpeed)))
        
        backgroundCivilian = SKSpriteNode(imageNamed: "Character_" + crowdMatrix[infectedIndex] + "_0")
        backgroundCivilian.position = infectedCivilian.position
        backgroundCivilian.zPosition = Layer.civilian - 1
        backgroundCivilian.size = CGSize(width: Size.characterWidth*1.5, height: Size.characterHeight)
        backgroundCivilian.name = "backgroundCivilian"
        let animation = SKAction.animate(with: [infectedCivilian1, infectedCivilian2, infectedCivilian3, infectedCivilian4, infectedCivilian5, infectedCivilian6], timePerFrame:0.2)
        backgroundCivilian.run(SKAction.repeatForever(animation))
        
        backgroundCivilian.physicsBody?.categoryBitMask = PhysicsCategory.infectedCivilian
        backgroundCivilian.physicsBody?.contactTestBitMask = PhysicsCategory.player
        backgroundCivilian.physicsBody?.collisionBitMask = PhysicsCategory.player
        backgroundCivilian.physicsBody?.isDynamic = true

        
        addChild(backgroundCivilian)
        
        backgroundCivilian.run(SKAction.moveBy(x: 0.0, y: frame.size.height + backgroundCivilian.size.height, duration: TimeInterval(civilianSpeed)))
        
       
    }
    
    func speedUpCivilian() {
        if score <= 25 {
            civilianSpeed = 2.3
        } else if score > 25 && score <= 50 {
            infectedCivTimer = 10.0
            civilianSpeed = 2.2
        } else if score > 50 && score <= 75 {
            civilianSpeed = 2.1
        } else if score > 75 && score <= 100 {
            civilianSpeed = 2.0
            infectedCivTimer = 8.0
        } else if score > 100 && score <= 150 {
            civilianSpeed = 1.9
            pointsMultiplier = 2
            infectedCivTimer = 7.0
        }
        //        else if score > 150 {
        //            pointsMultiplier = 2
        //            infectedCivTimer = 6.0
        //            civilianSpeed = 1.7
        //        } else if score > 500 {
        //            pointsMultiplier = 2
        //            infectedCivTimer = 5.0
        //            civilianSpeed = 1.6
        //        } else if score > 1000 {
        //            pointsMultiplier = 2
        //            infectedCivTimer = 4.0
        //            civilianSpeed = 1.5
        //        }
        print(civilianSpeed)
    }
    
    func startingCrowd(i: Double, j: Double) {
        
        var i = i
        var j = j
        var crowdRaw : Bool = true
        
        while crowdRaw {
            if i < 4.00 {
                startingCrowd = SKSpriteNode(imageNamed: "Perchiazzetto_0")
                startingCrowd.zPosition = crowdZ
                startingCrowd.size = CGSize(width: Size.crowdWidth, height: Size.crowdHeight)
                startingCrowd.name = "startingCrowd"
                startingCrowd.position = CGPoint(x: frame.midX/2 + (CGFloat(i) + 0.5)  * startingCrowd.size.width , y: (frame.maxY - 100) + (CGFloat(j)) * -startingCrowd.size.height)
                
                
                let crowdTxtA = SKTexture(imageNamed: "Character_" + crowdMatrix[crowdIndex] + "_1")
                let crowdTxtB = SKTexture(imageNamed: "Character_" + crowdMatrix[crowdIndex] + "_2")
                let animation = SKAction.animate(with: [crowdTxtA, crowdTxtB], timePerFrame:0.25)
                
                startingCrowd.physicsBody = SKPhysicsBody(rectangleOf: startingCrowd.size)
                startingCrowd.physicsBody?.categoryBitMask = PhysicsCategory.crowd
                startingCrowd.physicsBody?.contactTestBitMask = PhysicsCategory.civilian | PhysicsCategory.infectedCivilian | PhysicsCategory.potion
                startingCrowd.physicsBody?.collisionBitMask = PhysicsCategory.civilian | PhysicsCategory.player | PhysicsCategory.infectedCivilian | PhysicsCategory.potion
                startingCrowd.physicsBody?.affectedByGravity = false
                startingCrowd.physicsBody?.isDynamic = false
                
                startingCrowd.run(SKAction.repeatForever(animation))
                addChild(startingCrowd)
                
                backgroundStartingCrowd = SKSpriteNode(imageNamed: "Character_" + crowdMatrix[civilianIndex] + "_0")
                backgroundStartingCrowd.position = startingCrowd.position
                backgroundStartingCrowd.zPosition = crowdZ - 1
                backgroundStartingCrowd.size = CGSize(width: Size.crowdWidth, height: Size.crowdHeight)
                backgroundStartingCrowd.name = "backgroundStartingCrowd"
                let animation2 = SKAction.animate(with: [infectedAnimation1, infectedAnimation2, infectedAnimation3, infectedAnimation4, infectedAnimation5, infectedAnimation6], timePerFrame:0.2)
                backgroundStartingCrowd.run(SKAction.repeatForever(animation2))
                addChild(backgroundStartingCrowd)
                
                let moveUp = SKAction.moveTo(x: startingCrowd.position.x - 10, duration: 1)
                let moveDown = SKAction.moveTo(x: startingCrowd.position.x + 10, duration: 1)
                
                let sequence = SKAction.sequence([moveUp, moveDown])
                let repeatAction = SKAction.repeatForever(sequence)
                
                backgroundStartingCrowd.run(repeatAction)
                
                crowdZ += 1
                
                startingCrowd.run(repeatAction)
                
                i += 0.50
                if crowdIndex == 15 {
                    crowdIndex = 0
                } else {
                    crowdIndex += 1
                }
                
            } else {
                
                j += 0.50
                i = 0.0
            }
            if j == 0.50 {
                crowdRaw = false
            }
        }
    }
    
    func crowdAsses() {
        assX += 0.5
        if assX == 4.0 {
            assX = 0
            assY += 0.5
        }
        if crowdIndex == 15 {
            crowdIndex = 0
        } else {
            crowdIndex += 1
        }
    }
    
    func createCrowd() {
        
        if assX < 4.00 {
            crowd = SKSpriteNode(imageNamed: "Perchiazzetto_0")
            crowd.zPosition = crowdZ
            crowd.size = CGSize(width: Size.crowdWidth, height: Size.crowdHeight)
            crowd.name = "crowd"
            
            crowd.position = CGPoint(x: frame.midX/2 + (CGFloat(assX) + 0.5) * crowd.size.width , y: (frame.maxY - 100) + (CGFloat(assY)) * -crowd.size.height)
            
            let crowdTxtA = SKTexture(imageNamed: "Character_" + crowdMatrix[crowdIndex] + "_1")
            let crowdTxtB = SKTexture(imageNamed: "Character_" + crowdMatrix[crowdIndex] + "_2")
            let animation = SKAction.animate(with: [crowdTxtA, crowdTxtB], timePerFrame:0.25)
            
            crowd.physicsBody = SKPhysicsBody(rectangleOf: crowd.size)
            
            crowd.physicsBody?.categoryBitMask = PhysicsCategory.crowd
            crowd.physicsBody?.contactTestBitMask = PhysicsCategory.civilian | PhysicsCategory.player | PhysicsCategory.potion
            crowd.physicsBody?.collisionBitMask = PhysicsCategory.civilian | PhysicsCategory.player | PhysicsCategory.potion
            crowd.physicsBody?.affectedByGravity = false
            crowd.physicsBody?.isDynamic = false
            
            crowd.run(SKAction.repeatForever(animation))
            
            let beingInfected = SKAction.animate(with: [exp1, exp2, exp3, exp4, exp5, exp6, exp7], timePerFrame: 0.04)
            crowd.run(beingInfected)
            
            backgroundCrowd = SKSpriteNode(imageNamed: "Character_" + crowdMatrix[civilianIndex] + "_0")
            backgroundCrowd.position = crowd.position
            backgroundCrowd.zPosition = crowdZ - 1
            backgroundCrowd.size = CGSize(width: Size.crowdWidth, height: Size.crowdHeight)
            backgroundCrowd.name = "backgroundCrowd"
            let animation2 = SKAction.animate(with: [infectedAnimation1, infectedAnimation2, infectedAnimation3, infectedAnimation4, infectedAnimation5, infectedAnimation6], timePerFrame:0.2)
            backgroundCrowd.run(SKAction.repeatForever(animation2))
            
            let moveUp = SKAction.moveTo(x: crowd.position.x - 10, duration: 1)
            let moveDown = SKAction.moveTo(x: crowd.position.x + 10, duration: 1)
            let sequence = SKAction.sequence([moveUp, moveDown])
            let repeatAction = SKAction.repeatForever(sequence)
            
            crowd.run(repeatAction)
            
            addChild(crowd)
            addChild(backgroundCrowd)
            backgroundCrowd.run(animation2)
            backgroundCrowd.run(repeatAction)
            
        }
        
    }
    
    func createPotion(){
        potion = SKSpriteNode(imageNamed: "potion_0")
        potion.name = "potion"
        potion.size = CGSize(width: Size.characterWidth/1.2, height: Size.characterHeight/1.2)
        potion.position = CGPoint(x: random(min: frame.midX/2, max: frame.midX + (frame.midX/2)), y: frame.minY)
        potion.zPosition = Layer.potion
        potion.run(SKAction.moveBy(x: 0.0, y: frame.size.height + civilian.size.height, duration: TimeInterval(civilianSpeed)))
        
        potion.physicsBody = SKPhysicsBody(rectangleOf: potion.size)
        potion.physicsBody?.categoryBitMask = PhysicsCategory.potion
        potion.physicsBody?.contactTestBitMask = PhysicsCategory.player
        potion.physicsBody?.collisionBitMask = PhysicsCategory.player
        potion.physicsBody?.affectedByGravity = false
        potion.physicsBody?.isDynamic = false
        
        addChild(potion)
        
    }
    
    func superPowerActivate() {
        
        powerActivate = SKSpriteNode(imageNamed: "newpower\(powerIndex)")
        powerActivate.name = "powerRemoveCrowd"
        powerActivate.position = CGPoint(x: frame.minX + 40, y: frame.minY + 40)
        powerActivate.size = CGSize(width: 75, height: 75)
        powerActivate.zPosition = Layer.pauseButtons
        
        addChild(powerActivate)
        
    }
    
    func removePowerButton() {
        powerActivate.removeFromParent()
    }
    
    func createScore() {
        
        scoreText = SKLabelNode(fontNamed: "Cipitillo")
        scoreText.fontSize = 20
        scoreText.fontColor = SKColor.customYellow!
        scoreText.position = CGPoint(x: frame.maxX - 40, y: frame.maxY - 45)
        scoreText.horizontalAlignmentMode = .center
        scoreText.zPosition = Layer.score
        scoreText.text = "SCORE"
        
        scoreLabel = SKLabelNode(fontNamed: "Cipitillo")
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = SKColor.customYellow!
        scoreLabel.position = CGPoint(x: frame.maxX - 40, y: frame.maxY - 65)
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.zPosition = Layer.score
        scoreLabel.text = "\(score)"
        
        scoreBG = SKSpriteNode(imageNamed: "scoreBG")
        scoreBG.position = CGPoint(x: frame.maxX - 40, y: frame.maxY - 45)
        scoreBG.zPosition = Layer.score - 1
        scoreBG.size = CGSize(width: 65, height: 50)
        
        
        addChild(scoreLabel)
        addChild(scoreText)
        addChild(scoreBG)
        
    }
    
    func collisionBetween(entityOne: SKNode, entityTwo: SKNode) {
        if entityOne.name == "civilian" {
            destroy(entity: entityOne)
            if civilianIndex == 16 {
                civilianIndex = 0
            } else {
                civilianIndex += 1
            }
        } else if entityTwo.name == "civilian" {
            destroy(entity: entityTwo)
            if civilianIndex == 16 {
                civilianIndex = 0
            } else {
                civilianIndex += 1
            }
        } else if entityOne.name == "potion" {
            destroy(entity: entityOne)
        } else if entityTwo.name == "potion" {
            destroy(entity: entityTwo)
        }
        
    }
    
    func destroy(entity: SKNode) {
        entity.removeFromParent()
        score -= 1
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        
        if contact.bodyA.node?.name == "civilian" && contact.bodyB.node?.name == "crowd" {
            
            collisionBetween(entityOne: contact.bodyA.node!, entityTwo: contact.bodyB.node!)
            createCivilian()
            print("first Case")
            crowdZ += 1
            assX += 0.5
            if assX == 4.0 {
                assX = 0
                assY += 0.5
            }
            if crowdIndex == 15 {
                crowdIndex = 0
            } else {
                crowdIndex += 1
            }
            createCrowd()
            
        } else if contact.bodyA.node?.name == "crowd" && contact.bodyB.node?.name == "civilian" {
            
            collisionBetween(entityOne: contact.bodyB.node!, entityTwo: contact.bodyA.node!)
            createCivilian()
            print("second Case")
            crowdZ += 1
            assX += 0.5
            if assX == 4.0 {
                assX = 0
                assY += 0.5
            }
            if crowdIndex == 15 {
                crowdIndex = 0
            } else {
                crowdIndex += 1
            }
            createCrowd()
            
        } else if contact.bodyA.node?.name == "civilian" && contact.bodyB.node?.name == "startingCrowd" {
            
            collisionBetween(entityOne: contact.bodyA.node!, entityTwo: contact.bodyB.node!)
            createCivilian()
            print("first Case")
            crowdZ += 1
            assX += 0.5
            if assX == 4.0 {
                assX = 0
                assY += 0.5
            }
            if crowdIndex == 15 {
                crowdIndex = 0
            } else {
                crowdIndex += 1
            }
            createCrowd()
            
        } else if contact.bodyA.node?.name == "startingCrowd" && contact.bodyB.node?.name == "civilian" {
            
            collisionBetween(entityOne: contact.bodyB.node!, entityTwo: contact.bodyA.node!)
            createCivilian()
            print("second Case")
            crowdZ += 1
            assX += 0.5
            if assX == 4.0 {
                assX = 0
                assY += 0.5
            }
            if crowdIndex == 15 {
                crowdIndex = 0
            } else {
                crowdIndex += 1
            }
            createCrowd()
            
        } else if contact.bodyA.node?.name == "player" && contact.bodyB.node?.name == "potion" {
            print("Pozione 1")
            collisionBetween(entityOne: contact.bodyA.node!, entityTwo: contact.bodyB.node!)
            
            if UserDefaults.standard.bool(forKey: "soundSetting") == true {
                self.run(SoundFX.potion)
            }
            
            if powerIndex < 10 {
                powerIndex += 1
            } else {
                powerIndex = 10
            }
            
            removePowerButton()
            superPowerActivate()
            
        } else if contact.bodyA.node?.name == "potion" && contact.bodyB.node?.name == "player" {
            print("Pozione 2")
            
            collisionBetween(entityOne: contact.bodyA.node!, entityTwo: contact.bodyB.node!)
            
            if UserDefaults.standard.bool(forKey: "soundSetting") == true {
                self.run(SoundFX.potion)
            }
            
            if powerIndex < 10 {
                powerIndex += 1
            } else {
                powerIndex = 10
            }
            removePowerButton()
            superPowerActivate()
            
        
        } else if contact.bodyA.node?.name == "player" {
            if contact.bodyB.node!.name == "crowd" {
                print("Game Over")
                gameOver()
            }
        } else if contact.bodyB.node?.name == "player" {
            if contact.bodyA.node!.name == "crowd" {
                print("Game Over")
                gameOver()
            }
        }
        
        if contact.bodyA.node?.name == "player" {
           if contact.bodyB.node!.name == "infectedCivilian" {
               print("Game Over")
               gameOver()
           }
       } else if contact.bodyA.node?.name == "infectedCivilian" {
           if contact.bodyB.node!.name == "player" {
               print("Game Over")

               gameOver()
           }
       }
    }
    
    
    
    func pauseButton() {
        
        pause.name = "pausa"
        pause.position = CGPoint(x: frame.minX + 40, y: frame.maxY - 45)
        pause.size = CGSize(width: 62, height: 62)
        pause.zPosition = Layer.pauseButtons
        addChild(pause)
        
    }
    
    func pauseGame() {
        
        self.scene?.isPaused = true
        sceneDelegate?.gameWasPaused()
        pause.removeFromParent()
        
        barra = SKSpriteNode(imageNamed: "option3")
        barradietro = SKSpriteNode()
        buttonresume = SKSpriteNode(imageNamed: "resumeButton".localized())
        retryButton = SKSpriteNode(imageNamed: "retrylevel".localized())
        exitButton = SKSpriteNode(imageNamed: "exitlevel".localized())
        
        barradietro.name = "sfondodietro"
        barradietro.zPosition = Layer.pauseGame
        barradietro.color = SKColor.black
        barradietro.size = CGSize(width: frame.maxX * 2, height: frame.maxY * 2)
        barradietro.position = CGPoint(x: frame.minX, y: frame.minY)
        barradietro.alpha = 0.5
        
        barra.name = "bar"
        barra.size = CGSize(width: 357, height: 337)
        barra.position = CGPoint(x: frame.midX, y: frame.midY)
        barra.zPosition = Layer.pauseBackground
        barra.alpha = 1
        
        buttonresume.name = "buttonresume"
        buttonresume.zPosition = Layer.pauseButtons
        buttonresume.color = SKColor.black
        buttonresume.size = CGSize(width: 268, height: 61)
        buttonresume.position = CGPoint(x: frame.midX, y: frame.midY + 100)
        buttonresume.alpha = 1
        
        retryButton.name = "retryButton"
        retryButton.zPosition = Layer.pauseButtons
        retryButton.color = SKColor.black
        retryButton.size = CGSize(width: 268, height: 61)
        retryButton.position = CGPoint(x: frame.midX, y: frame.midY)
        retryButton.alpha = 1
        
        exitButton.name = "exitButton"
        exitButton.zPosition = Layer.pauseButtons
        exitButton.color = SKColor.black
        exitButton.size = CGSize(width: 268, height: 61)
        exitButton.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        exitButton.alpha = 1
        
        addChild(barradietro)
        addChild(barra)
        addChild(buttonresume)
        addChild(retryButton)
        addChild(exitButton)
        
    }
    
    func exitLevel() {
        
        barraExit = SKSpriteNode(imageNamed: "option2")
        barradietro = SKSpriteNode()
        exitLabel = SKSpriteNode(imageNamed: "exit".localized())
        exitYes = SKSpriteNode(imageNamed: "yes".localized())
        exitNo = SKSpriteNode(imageNamed: "no".localized())
        
        barradietro.name = "sfondodietro"
        barradietro.zPosition = Layer.pauseGame
        barradietro.color = SKColor.black
        barradietro.size = CGSize(width: frame.maxX * 2, height: frame.maxY * 2)
        barradietro.position = CGPoint(x: frame.minX, y: frame.minY)
        barradietro.alpha = 0.5
        
        barraExit.name = "barraExit"
        barraExit.size = CGSize(width: 357, height: 180)
        barraExit.position = CGPoint(x: frame.midX, y: frame.midY)
        barraExit.zPosition = Layer.pauseBackground
        barraExit.alpha = 1
        
        exitLabel.name = "exitLabel"
        exitLabel.zPosition = Layer.settingLabel
        exitLabel.size = CGSize(width: Int("114".localized())!, height: 41)
        exitLabel.position = CGPoint(x: frame.midX, y: frame.midY + 40)
        exitLabel.alpha = 1
        
        exitYes.name = "exitYes"
        exitYes.zPosition = Layer.settingLabel
        exitYes.size = CGSize(width: 120, height: 61)
        exitYes.position = CGPoint(x: frame.midX + frame.midX / 2.5, y: frame.midY - 40)
        exitYes.alpha = 1
        
        exitNo.name = "exitNo"
        exitNo.zPosition = Layer.settingLabel
        exitNo.size = CGSize(width: 120, height: 61)
        exitNo.position = CGPoint(x: frame.midX - frame.midX / 2.5, y: frame.midY - 40)
        exitNo.alpha = 1
        
        
        addChild(barradietro)
        addChild(barraExit)
        addChild(exitLabel)
        addChild(exitYes)
        addChild(exitNo)
        
    }
    
    func recordBestScore() {
        let userDefaults = UserDefaults.standard
        var bestScore = userDefaults.integer(forKey: "bestScore")
        
        if self.score > bestScore {
            bestScore = self.score
            userDefaults.set(bestScore, forKey: "bestScore")
        }
        userDefaults.synchronize()
    }
    
    func gameOver() {
        
        recordBestScore()
        
        self.scene?.isPaused = true
        sceneDelegate?.gameWasPaused()
        pause.removeFromParent()
        
        gameOverBG = SKSpriteNode(imageNamed: "option1")
        bestScoreBG = SKSpriteNode(imageNamed: "scorerectangle")
        actualScoreBG = SKSpriteNode(imageNamed: "scorerectangle")
        gameOverRetry = SKSpriteNode(imageNamed: "restartbutton".localized())
        barradietro = SKSpriteNode()
        
        barradietro.name = "sfondodietro"
        barradietro.zPosition = Layer.pauseGame
        barradietro.color = SKColor.black
        barradietro.size = CGSize(width: frame.maxX * 2, height: frame.maxY * 2)
        barradietro.position = CGPoint(x: frame.minX, y: frame.minY)
        barradietro.alpha = 0.5
        
        gameOverBG.name = "gameOverBG"
        gameOverBG.size = CGSize(width: 357, height: 475)
        gameOverBG.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOverBG.zPosition = Layer.pauseBackground
        gameOverBG.alpha = 1
        
        actualScoreLabel.name = "actualScoreLabel"
        actualScoreLabel = SKLabelNode(fontNamed: "Cipitillo")
        actualScoreLabel.fontSize = 35
        actualScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY + 175)
        actualScoreLabel.zPosition = Layer.pauseButtons
        actualScoreLabel.text = "Your Score".localized()
        actualScoreLabel.color = SKColor.black
        actualScoreLabel.colorBlendFactor = 1
        
        actualScoreBG.name = "actualScoreBG"
        actualScoreBG.zPosition = Layer.pauseButtons
        actualScoreBG.position = CGPoint(x: frame.midX, y: frame.midY + 100)
        actualScoreBG.size = CGSize(width: 167, height: 96)
        actualScoreBG.alpha = 1
        
        let levelScore = SKLabelNode(fontNamed: "Cipitillo")
        levelScore.name = "levelScore"
        levelScore.fontSize = 50
        levelScore.position = CGPoint(x: frame.midX, y: frame.midY + 85)
        levelScore.zPosition = Layer.settingLabel
        levelScore.text = "\(score)"
        levelScore.color = SKColor.customYellow
        levelScore.colorBlendFactor = 1
        
        bestScoreLabel.name = "bestScoreLabel"
        bestScoreLabel = SKLabelNode(fontNamed: "Cipitillo")
        bestScoreLabel.fontSize = 35
        bestScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        bestScoreLabel.zPosition = Layer.pauseButtons
        bestScoreLabel.text = "Best Score".localized()
        bestScoreLabel.color = SKColor.black
        bestScoreLabel.colorBlendFactor = 1
        
        bestScoreBG.name = "bestScoreBG"
        bestScoreBG.zPosition = Layer.pauseButtons
        bestScoreBG.position = CGPoint(x: frame.midX, y: frame.midY - 75)
        bestScoreBG.size = CGSize(width: 167, height: 96)
        bestScoreBG.alpha = 1
        
        let bestScore = UserDefaults.standard.integer(forKey: "bestScore")
        let actualBestScore = SKLabelNode(fontNamed: "Cipitillo")
        actualBestScore.fontSize = 50
        actualBestScore.position = CGPoint(x: frame.midX, y: frame.midY - 90)
        actualBestScore.zPosition = Layer.settingLabel
        actualBestScore.text = "\(bestScore)"
        actualBestScore.color = SKColor.customYellow
        actualBestScore.colorBlendFactor = 1
        
        gameOverRetry.name = "gameOverRetry"
        gameOverRetry.zPosition = Layer.pauseButtons
        gameOverRetry.size = CGSize(width: 268, height: 61)
        gameOverRetry.position = CGPoint(x: frame.midX, y: frame.midY - 175)
        gameOverRetry.alpha = 1
        
        addChild(barradietro)
        addChild(gameOverBG)
        addChild(actualScoreLabel)
        addChild(actualScoreBG)
        addChild(levelScore)
        addChild(bestScoreLabel)
        addChild(bestScoreBG)
        addChild(gameOverRetry)
        addChild(actualBestScore)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if civilianIndex >= 16 {
            civilianIndex = 0
        }
        
        if infectedCivilian.position.y >= frame.maxY {
            infectedCivilian.removeFromParent()
            backgroundCivilian.removeFromParent()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch gameState {
        case .ready:
            gameState = .playing
        case .playing:
            for touch in touches {
                let location = touch.location(in: self)
                for node in self.nodes(at: location){
                    if node.name == "civilian"  {
                        civilian.removeAllActions()
                        let animation = SKAction.animate(with: [heal1 ,heal2, heal3, heal4, heal5], timePerFrame: 0.075)
                        
                        node.run(animation, completion: {
                            node.removeFromParent()
                            self.score += (1 * self.pointsMultiplier)
                            
                            if UserDefaults.standard.bool(forKey: "soundSetting") == true {
                                self.run(SoundFX.healing)
                            }
                            
                            if self.civilianIndex == 16 {
                                self.civilianIndex = 0
                            } else {
                                self.civilianIndex += 1
                            }
                            self.createCivilian()
                            
                        })
                    }  else if node.name == "pausa" {
                        
                        pauseGame()
                        powerActivate.removeFromParent()
                        
                    } else if node.name == "buttonresume" {
                        
                        barra.removeFromParent()
                        barradietro.removeFromParent()
                        buttonresume.removeFromParent()
                        retryButton.removeFromParent()
                        exitButton.removeFromParent()
                        self.scene?.isPaused = false
                        addChild(pause)
                        addChild(powerActivate)
                        
                    } else if node.name == "retryButton" {
                        
                        let newScene = GameScene(size: self.size)
                        let animation = SKTransition.fade(withDuration: 1.0)
                        self.view?.presentScene(newScene, transition: animation)
                        
                    } else if node.name == "exitButton" {
                        
                        barra.removeFromParent()
                        barradietro.removeFromParent()
                        buttonresume.removeFromParent()
                        retryButton.removeFromParent()
                        exitButton.removeFromParent()
                        exitLevel()
                        
                    } else if node.name == "exitNo" {
                        
                        barraExit.removeFromParent()
                        barradietro.removeFromParent()
                        exitLabel.removeFromParent()
                        exitYes.removeFromParent()
                        exitNo.removeFromParent()
                        self.scene?.isPaused = false
                        addChild(pause)
                        
                    } else if node.name == "exitYes" {
                        
                        let newScene = MainMenu(size: (view?.bounds.size)!)
                        let animation = SKTransition.fade(withDuration: 1.0)
                        self.view?.presentScene(newScene, transition: animation)
                        
                    } else if node.name == "gameOverRetry" {
                        
                        let newScene = GameScene(size: self.size)
                        let animation = SKTransition.fade(withDuration: 1.0)
                        self.view?.presentScene(newScene, transition: animation)
                        
                    } else if node.name == "infectedCivilian" {
                        score -= 2
                        infectedCivilian.removeFromParent()
                        backgroundCivilian.removeFromParent()
                        crowdAsses()
                        crowdZ += 1
                        createCrowd()
                        crowdZ += 1
                        crowdAsses()
                        createCrowd()
                    } else if node.name == "powerRemoveCrowd" {
                        if powerIndex == 10 {
                            for child in self.children {
                                let animation = SKAction.animate(with: [heal1 ,heal2, heal3, heal4, heal5], timePerFrame: 0.075)
                                if child.name == "crowd" {
                                    child.run(SKAction.stop())
                                    child.run(animation, completion: {
                                        child.removeFromParent()
                                    } )
                                } else if child.name == "backgroundCrowd" {
                                    child.run(SKAction.stop())
                                    child.run(animation, completion: {
                                        child.removeFromParent()
                                    } )
                                }
                                assX = 0.0
                                assY = 0.5
                                crowdZ = 11
                            }
                            powerIndex = 0
                            removePowerButton()
                            superPowerActivate()
                        }
                    }
                }
            }
        case .dead:
            print("Game over")
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            player.position.x = location.x/1.92 + 85
        }
        
    }
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        moveBackground(image: ["Background_1", "Background_2", "Background_3", "Background_4", "Background_5", "Background_6", "Background_7", "Background_8", "Background_9", "Background_1"], x: frame.minX, z: -3, duration: 30, size: CGSize(width: frame.width, height: frame.height))
        
        createPlayer()
        
        createCivilian()
        
        startingCrowd(i: 0.0, j: 0.0)
        
        pauseButton()
        
        createScore()
        
        superPowerActivate()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
            self.run(SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run(self.createPotion),
                    SKAction.wait(forDuration: 10.0)])))
        })
        
        musicLevel = SKAudioNode(fileNamed: "levelMusic.mp3")
        musicLevel.autoplayLooped = true
        self.addChild(musicLevel)
        
        if UserDefaults.standard.bool(forKey: "musicVolume") == true {
            musicLevel.run(SKAction.changeVolume(to: 1, duration: 0))
        } else {
            musicLevel.run(SKAction.changeVolume(to: 0, duration: 0))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 12, execute: {
            self.run(SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run(self.createInfectedCivilian),
                    SKAction.wait(forDuration: self.infectedCivTimer)])))
        })
        
    }
}
