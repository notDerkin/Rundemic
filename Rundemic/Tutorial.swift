//
//  Tutorial.swift
//  TestGame
//
//  Created by Raffaele Siciliano on 07/03/22.
//

import SpriteKit

class Tutorial: SKScene, SKPhysicsContactDelegate {
    
    var bar = SKShapeNode()
    
    var backButton = SKSpriteNode()
    
    var musicLevel = SKAudioNode()
    
    var player = SKSpriteNode()
    
    let perkA = SKTexture(imageNamed: UserDefaults.standard.string(forKey: "textureOne") ?? "Perchy_1")
    let perkB = SKTexture(imageNamed: UserDefaults.standard.string(forKey: "textureTwo") ?? "Perchy_2")
    
    var crowdMatrix : [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "L", "M", "N", "O", "P", "Q", "R", "S"]
    var crowdIndex = 0
    var civilianIndex = 0
    var civilian = SKSpriteNode()
    var unstoppableCivilian = SKSpriteNode()
    var civilianSpeed : CGFloat = 2.2
    
    var startingCrowd = SKSpriteNode()
    var backgroundStartingCrowd = SKSpriteNode()
    var crowd = SKSpriteNode()
    var backgroundCrowd = SKSpriteNode()
    var assX : Double = 0.0
    var assY : Double = 0.5
    var crowdZ : CGFloat = 3
    
    var infectedCivilian = SKSpriteNode()
    var infectedCivTimer = 12.0
    var backgroundCivilian = SKSpriteNode()
    
    var saveCivilian = SKLabelNode()
    var saveCivilianBG = SKLabelNode()
    
    var becomeInfected1 = SKLabelNode()
    var becomeInfected1BG = SKLabelNode()
    var becomeInfected2 = SKLabelNode()
    var becomeInfected2BG = SKLabelNode()
    
    var infectedSpy1 = SKLabelNode()
    var infectedSpy1BG = SKLabelNode()
    var infectedSpy2 = SKLabelNode()
    var infectedSpy2BG = SKLabelNode()
    
    var powerLabel1 = SKLabelNode()
    var powerLabel1BG = SKLabelNode()
    var powerLabel2 = SKLabelNode()
    var powerLabel2BG = SKLabelNode()
    
    var end1 = SKLabelNode()
    var end1BG = SKLabelNode()
    var end2 = SKLabelNode()
    var end2BG = SKLabelNode()
    
    var powerActivate = SKSpriteNode()
    var powerIndex = 9
    
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
    
    var potion = SKSpriteNode()
    
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
    
    //    MARK: All Environment
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "Perchiazzetto_0")
        
        player.position = CGPoint(x: frame.midX, y: frame.midY)
        player.zPosition = Layer.player
        player.size = CGSize(width: Size.characterWidth, height: Size.characterHeight)
        
        player.name = "player"
        let animation = SKAction.animate(with: [perkA, perkB], timePerFrame:0.2)
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.crowd | PhysicsCategory.potion
        player.physicsBody?.collisionBitMask = PhysicsCategory.crowd | PhysicsCategory.potion
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = false
        
        addChild(player)
        player.run(SKAction.repeatForever(animation))
        
    }
    
    func createCivilian() {
        
        print(civilianIndex)
        
        civilian = SKSpriteNode(imageNamed: "Character_" + crowdMatrix[civilianIndex] + "_0")
        civilian.position = CGPoint(x: frame.midX - 60, y: frame.minY)
        civilian.zPosition = Layer.civilian
        civilian.size = CGSize(width: Size.characterWidth, height: Size.characterHeight)
        civilian.name = "civilian"
        
        civilian.physicsBody = SKPhysicsBody(rectangleOf: civilian.size)
        civilian.physicsBody?.categoryBitMask = PhysicsCategory.civilian
        civilian.physicsBody?.contactTestBitMask = PhysicsCategory.crowd
        civilian.physicsBody?.collisionBitMask = PhysicsCategory.crowd
        civilian.physicsBody?.affectedByGravity = false
        civilian.physicsBody?.isDynamic = true
        
        civilian.run(SKAction.moveBy(x: 0.0, y: frame.midY - 100, duration: TimeInterval(civilianSpeed)))
        
        addChild(civilian)
        
    }
    
    func createUnstoppableCivilian() {
        
        
        unstoppableCivilian = SKSpriteNode(imageNamed: "Character_" + crowdMatrix[civilianIndex] + "_0")
        unstoppableCivilian.position = CGPoint(x: frame.midX - 60, y: frame.minY)
        unstoppableCivilian.zPosition = Layer.civilian
        unstoppableCivilian.size = CGSize(width: Size.characterWidth, height: Size.characterHeight)
        unstoppableCivilian.name = "unstoppableCivilian"
        
        unstoppableCivilian.physicsBody = SKPhysicsBody(rectangleOf: civilian.size)
        unstoppableCivilian.physicsBody?.categoryBitMask = PhysicsCategory.civilian
        unstoppableCivilian.physicsBody?.contactTestBitMask = PhysicsCategory.crowd
        unstoppableCivilian.physicsBody?.collisionBitMask = PhysicsCategory.crowd
        unstoppableCivilian.physicsBody?.affectedByGravity = false
        unstoppableCivilian.physicsBody?.isDynamic = true
        
        unstoppableCivilian.run(SKAction.moveBy(x: 0.0, y: frame.maxY + unstoppableCivilian.size.height, duration: TimeInterval(civilianSpeed)))
        
        addChild(unstoppableCivilian)
        
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
            backgroundCrowd.zPosition = 0.1
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
    
    
    
    func createInfectedCivilian() {
        
        var infectedIndex = 0
        if civilianIndex == 0 {
            infectedIndex = civilianIndex + 3
        } else {
            infectedIndex = civilianIndex - 1
        }
        
        infectedCivilian = SKSpriteNode(imageNamed: "Character_" + crowdMatrix[infectedIndex] + "_0")
        infectedCivilian.position = CGPoint(x: frame.midX + 65, y: frame.minY)
        infectedCivilian.zPosition = crowdZ
        infectedCivilian.size = CGSize(width: Size.characterWidth, height: Size.characterHeight)
        infectedCivilian.name = "infectedCivilian"
        
        addChild(infectedCivilian)
        
        infectedCivilian.run(SKAction.moveBy(x: 0.0, y: frame.midY - 100, duration: TimeInterval(civilianSpeed)))
        
        backgroundCivilian = SKSpriteNode(imageNamed: "Character_" + crowdMatrix[infectedIndex] + "_0")
        backgroundCivilian.position = infectedCivilian.position
        backgroundCivilian.zPosition = crowdZ - 1
        backgroundCivilian.size = CGSize(width: Size.characterWidth*1.5, height: Size.characterHeight)
        backgroundCivilian.name = "backgroundCivilian"
        let animation = SKAction.animate(with: [infectedCivilian1, infectedCivilian2, infectedCivilian3, infectedCivilian4, infectedCivilian5, infectedCivilian6], timePerFrame:0.2)
        backgroundCivilian.run(SKAction.repeatForever(animation))
        addChild(backgroundCivilian)
        
        backgroundCivilian.run(SKAction.moveBy(x: 0.0, y: frame.midY - 100, duration: TimeInterval(civilianSpeed)))
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5, execute: {
            self.infectedCivilian.run(SKAction.fadeOut(withDuration: 1.2))
            self.backgroundCivilian.run(SKAction.fadeOut(withDuration: 1.2))
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: {
                self.powerLabel()
            })
        })
        
        
    }
    
    func createPotion() {
        
        potion = SKSpriteNode(imageNamed: "potion_0")
        potion.size = CGSize(width: Size.characterWidth/1.2, height: Size.characterHeight/1.2)
        potion.position = CGPoint(x: frame.midX + 50, y: frame.minY)
        potion.zPosition = Layer.potion
        potion.run(SKAction.moveBy(x: 0.0, y: frame.midY, duration: TimeInterval(civilianSpeed)))
        
        potion.name = "potion"
        
        potion.physicsBody = SKPhysicsBody(rectangleOf: potion.size)
        potion.physicsBody?.categoryBitMask = PhysicsCategory.potion
        potion.physicsBody?.contactTestBitMask = PhysicsCategory.player
        potion.physicsBody?.collisionBitMask = PhysicsCategory.player
        potion.physicsBody?.affectedByGravity = false
        potion.physicsBody?.isDynamic = true
        
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
    
    func createBackButton() {
        backButton = SKSpriteNode(imageNamed: "back")
        backButton.name = "backButton"
        backButton.zPosition = Layer.pauseButtons
        backButton.size = CGSize(width: 64, height: 64)
        backButton.position = CGPoint(x: frame.minX + 40, y: frame.maxY - 40)
        backButton.alpha = Layer.pauseButtons
        
        addChild(backButton)
    }
    
    //    MARK: Crowd settings
    
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
    
    func settingCrowd() {
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
    }
    
    func spawnCrowd() {
        settingCrowd()
        createCrowd()
        settingCrowd()
        createCrowd()
        settingCrowd()
        createCrowd()
        settingCrowd()
        createCrowd()
        settingCrowd()
        createCrowd()
        settingCrowd()
        createCrowd()
        settingCrowd()
        createCrowd()
    }
    
    //    MARK: All the label
    
    func saveCivilianLabel() {
        
        saveCivilian.name = "saveCivilian"
        saveCivilian = SKLabelNode(fontNamed: "Cipitillo")
        saveCivilian.fontSize = 25
        saveCivilian.position = CGPoint(x: frame.midX, y: frame.midY + 155)
        saveCivilian.zPosition = Layer.pauseButtons
        saveCivilian.text = "Tap the civilians to save them".localized()
        saveCivilian.color = SKColor.customYellow
        saveCivilian.colorBlendFactor = 1
        
        bar = SKShapeNode(rectOf: CGSize(width: frame.width, height: 100))
        bar.name = "bar"
        bar.zPosition = Layer.pauseButtons - 1
        bar.fillColor = SKColor.customGray!
        bar.position = CGPoint(x: frame.midX, y: frame.midY + 165)
        bar.alpha = 0.4
        addChild(bar)
        
        saveCivilianBG.name = "saveCivilianBG"
        saveCivilianBG = SKLabelNode(fontNamed: "Cipitillo")
        saveCivilianBG.fontSize = 26
        saveCivilianBG.position = CGPoint(x: frame.midX, y: frame.midY + 155)
        saveCivilianBG.zPosition = Layer.pauseButtons - 1
        saveCivilianBG.text = "Tap the civilians to save them".localized()
        saveCivilianBG.color = SKColor.black
        saveCivilianBG.colorBlendFactor = 1
        
        addChild(saveCivilian)
        addChild(saveCivilianBG)
        
    }
    
    func removeSaveLabel() {
        saveCivilian.removeFromParent()
        saveCivilianBG.removeFromParent()
    }
    
    func tutorialInfected() {
        
        removeSaveLabel()
        becomeInfected1.name = "becomeInfected1"
        becomeInfected1 = SKLabelNode(fontNamed: "Cipitillo")
        becomeInfected1.fontSize = 25
        becomeInfected1.position = CGPoint(x: frame.midX, y: frame.midY + 165)
        becomeInfected1.zPosition = Layer.pauseButtons
        becomeInfected1.text = "if the civilian reach the crowd".localized()
        becomeInfected1.color = SKColor.customYellow
        becomeInfected1.colorBlendFactor = 1
        
        becomeInfected1BG.name = "becomeInfected1BG"
        becomeInfected1BG = SKLabelNode(fontNamed: "Cipitillo")
        becomeInfected1BG.fontSize = 26
        becomeInfected1BG.position = CGPoint(x: frame.midX, y: frame.midY + 165)
        becomeInfected1BG.zPosition = Layer.pauseButtons - 1
        becomeInfected1BG.text = "if the civilian reach the crowd".localized()
        becomeInfected1BG.color = SKColor.black
        becomeInfected1BG.colorBlendFactor = 1
        
        becomeInfected2.name = "becomeInfected2"
        becomeInfected2 = SKLabelNode(fontNamed: "Cipitillo")
        becomeInfected2.fontSize = 25
        becomeInfected2.position = CGPoint(x: frame.midX, y: frame.midY + 140)
        becomeInfected2.zPosition = Layer.pauseButtons
        becomeInfected2.text = "they will become infected".localized()
        becomeInfected2.color = SKColor.customYellow
        becomeInfected2.colorBlendFactor = 1
        
        becomeInfected2BG.name = "becomeInfected2BG"
        becomeInfected2BG = SKLabelNode(fontNamed: "Cipitillo")
        becomeInfected2BG.fontSize = 26
        becomeInfected2BG.position = CGPoint(x: frame.midX, y: frame.midY + 140)
        becomeInfected2BG.zPosition = Layer.pauseButtons - 1
        becomeInfected2BG.text = "they will become infected".localized()
        becomeInfected2BG.color = SKColor.black
        becomeInfected2BG.colorBlendFactor = 1
        
        addChild(becomeInfected1)
        addChild(becomeInfected1BG)
        addChild(becomeInfected2)
        addChild(becomeInfected2BG)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.createUnstoppableCivilian()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.spyLabel()
            })
        })
        
    }
    
    func removeTutorialInfected() {
        becomeInfected1.removeFromParent()
        becomeInfected1BG.removeFromParent()
        becomeInfected2.removeFromParent()
        becomeInfected2BG.removeFromParent()
    }
    
    func spyLabel() {
        print("spy label richiamata")
        removeTutorialInfected()
        infectedSpy1.name = "infectedSpy1"
        infectedSpy1 = SKLabelNode(fontNamed: "Cipitillo")
        infectedSpy1.fontSize = 23
        infectedSpy1.position = CGPoint(x: frame.midX, y: frame.midY + 165)
        infectedSpy1.zPosition = Layer.pauseButtons
        infectedSpy1.text = "sometimes an infected will appear".localized()
        infectedSpy1.color = SKColor.customYellow
        infectedSpy1.colorBlendFactor = 1
        
        infectedSpy1BG.name = "infectedSpy1BG"
        infectedSpy1BG = SKLabelNode(fontNamed: "Cipitillo")
        infectedSpy1BG.fontSize = 24
        infectedSpy1BG.position = CGPoint(x: frame.midX, y: frame.midY + 165)
        infectedSpy1BG.zPosition = Layer.pauseButtons - 1
        infectedSpy1BG.text = "sometimes an infected will appear".localized()
        infectedSpy1BG.color = SKColor.black
        infectedSpy1BG.colorBlendFactor = 1
        
        infectedSpy2.name = "infectedSpy2"
        infectedSpy2 = SKLabelNode(fontNamed: "Cipitillo")
        infectedSpy2.fontSize = 23
        infectedSpy2.position = CGPoint(x: frame.midX, y: frame.midY + 140)
        infectedSpy2.zPosition = Layer.pauseButtons
        infectedSpy2.text = "avoid it and don't touch it!".localized()
        infectedSpy2.color = SKColor.customYellow
        infectedSpy2.colorBlendFactor = 1
        
        infectedSpy2BG.name = "infectedSpy2BG"
        infectedSpy2BG = SKLabelNode(fontNamed: "Cipitillo")
        infectedSpy2BG.fontSize = 24
        infectedSpy2BG.position = CGPoint(x: frame.midX, y: frame.midY + 140)
        infectedSpy2BG.zPosition = Layer.pauseButtons - 1
        infectedSpy2BG.text = "avoid it and don't touch it!".localized()
        infectedSpy2BG.color = SKColor.black
        infectedSpy2BG.colorBlendFactor = 1
        
        addChild(infectedSpy1)
        addChild(infectedSpy1BG)
        addChild(infectedSpy2)
        addChild(infectedSpy2BG)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.createInfectedCivilian()
        })
        
    }
    
    func removeSpyLabel() {
        infectedSpy1.removeFromParent()
        infectedSpy1BG.removeFromParent()
        infectedSpy2.removeFromParent()
        infectedSpy2BG.removeFromParent()
    }
    
    func powerLabel() {
        
        infectedCivilian.removeFromParent()
        backgroundCivilian.removeFromParent()
        removeSpyLabel()
        powerLabel1.name = "powerLabel1"
        powerLabel1 = SKLabelNode(fontNamed: "Cipitillo")
        powerLabel1.fontSize = 25
        powerLabel1.position = CGPoint(x: frame.midX, y: frame.midY + 165)
        powerLabel1.zPosition = Layer.pauseButtons
        powerLabel1.text = "pick up the potion".localized()
        powerLabel1.color = SKColor.customYellow
        powerLabel1.colorBlendFactor = 1
        
        powerLabel1BG.name = "powerLabel1BG"
        powerLabel1BG = SKLabelNode(fontNamed: "Cipitillo")
        powerLabel1BG.fontSize = 26
        powerLabel1BG.position = CGPoint(x: frame.midX, y: frame.midY + 165)
        powerLabel1BG.zPosition = Layer.pauseButtons - 1
        powerLabel1BG.text = "pick up the potion".localized()
        powerLabel1BG.color = SKColor.black
        powerLabel1BG.colorBlendFactor = 1
        
        powerLabel2.name = "powerLabel2"
        powerLabel2 = SKLabelNode(fontNamed: "Cipitillo")
        powerLabel2.fontSize = 25
        powerLabel2.position = CGPoint(x: frame.midX, y: frame.midY + 140)
        powerLabel2.zPosition = Layer.pauseButtons
        powerLabel2.text = "and heal the infected".localized()
        powerLabel2.color = SKColor.customYellow
        powerLabel2.colorBlendFactor = 1
        
        powerLabel2BG.name = "powerLabel2BG"
        powerLabel2BG = SKLabelNode(fontNamed: "Cipitillo")
        powerLabel2BG.fontSize = 26
        powerLabel2BG.position = CGPoint(x: frame.midX, y: frame.midY + 140)
        powerLabel2BG.zPosition = Layer.pauseButtons - 1
        powerLabel2BG.text = "and heal the infected".localized()
        powerLabel2BG.color = SKColor.black
        powerLabel2BG.colorBlendFactor = 1
        
        addChild(powerLabel1)
        addChild(powerLabel1BG)
        addChild(powerLabel2)
        addChild(powerLabel2BG)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.createPotion()
        })
        
    }
    
    func removePowerLabel() {
        powerLabel1.removeFromParent()
        powerLabel1BG.removeFromParent()
        powerLabel2.removeFromParent()
        powerLabel2BG.removeFromParent()
        bar.removeFromParent()
    }
    
    func endLabel() {
        removePowerLabel()
        end1.name = "end1"
        end1 = SKLabelNode(fontNamed: "Cipitillo")
        end1.fontSize = 30
        end1.position = CGPoint(x: frame.midX, y: frame.midY - 140)
        end1.zPosition = Layer.pauseButtons
        end1.text = "now it's time to".localized()
        end1.color = SKColor.customYellow
        end1.colorBlendFactor = 1
        
        end1BG.name = "end1BG"
        end1BG = SKLabelNode(fontNamed: "Cipitillo")
        end1BG.fontSize = 31
        end1BG.position = CGPoint(x: frame.midX, y: frame.midY - 140)
        end1BG.zPosition = Layer.pauseButtons - 1
        end1BG.text = "now it's time to".localized()
        end1BG.color = SKColor.black
        end1BG.colorBlendFactor = 1
        
        end2.name = "end2"
        end2 = SKLabelNode(fontNamed: "Cipitillo")
        end2.fontSize = 60
        end2.position = CGPoint(x: frame.midX, y: frame.midY - 195)
        end2.zPosition = Layer.pauseButtons
        end2.text = "run".localized()
        end2.color = SKColor.customYellow
        end2.colorBlendFactor = 1
        
        end2BG.name = "end2BG"
        end2BG = SKLabelNode(fontNamed: "Cipitillo")
        end2BG.fontSize = 64
        end2BG.position = CGPoint(x: frame.midX, y: frame.midY - 195)
        end2BG.zPosition = Layer.pauseButtons - 1
        end2BG.text = "run".localized()
        end2BG.color = SKColor.black
        end2BG.colorBlendFactor = 1
        
        bar = SKShapeNode(rectOf: CGSize(width: frame.width, height: 150))
        bar.name = "bar"
        bar.zPosition = Layer.pauseButtons - 1
        bar.fillColor = SKColor.customGray!
        bar.position = CGPoint(x: frame.midX, y: frame.midY - 155)
        bar.alpha = 0.4
        
        
        addChild(bar)
        addChild(end1)
        addChild(end1BG)
        addChild(end2)
        addChild(end2BG)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
            self.endTutorial()
        })
    }
    
    //    MARK: End tutorial
    
    func endTutorial() {
        
        if view != nil {
            let userDefaults = UserDefaults.standard
            if userDefaults.bool(forKey: "isTutorial") == false {
                userDefaults.set(true, forKey: "isTutorial")
                let scene : SKScene = GameScene(size: (view?.bounds.size)!)
                let transition: SKTransition = SKTransition.fade(withDuration: 1)
                self.view?.presentScene(scene, transition: transition)
            } else {
                let scene : SKScene = MainMenu(size: (view?.bounds.size)!)
                let transition: SKTransition = SKTransition.fade(withDuration: 1)
                self.view?.presentScene(scene, transition: transition)
            }
            
        }
    }
    
    
    //    MARK: Collision
    
    func collisionBetween(entityOne: SKNode, entityTwo: SKNode) {
        if entityOne.name == "unstoppableCivilian" {
            destroy(entity: entityOne)
            if civilianIndex == 16 {
                civilianIndex = 0
            } else {
                civilianIndex += 1
            }
        } else if entityTwo.name == "unstoppableCivilian" {
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
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "unstoppableCivilian" && contact.bodyB.node?.name == "startingCrowd" {
            
            collisionBetween(entityOne: contact.bodyA.node!, entityTwo: contact.bodyB.node!)
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
            removeTutorialInfected()
            
            
        } else if contact.bodyA.node?.name == "startingCrowd" && contact.bodyB.node?.name == "unstoppableCivilian" {
            
            collisionBetween(entityOne: contact.bodyB.node!, entityTwo: contact.bodyA.node!)
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
            removeTutorialInfected()
            
        } else if contact.bodyA.node?.name == "unstoppableCivilian" && contact.bodyB.node?.name == "crowd" {
            
            collisionBetween(entityOne: contact.bodyA.node!, entityTwo: contact.bodyB.node!)
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
            removeTutorialInfected()
            
        } else if contact.bodyA.node?.name == "crowd" && contact.bodyB.node?.name == "unstoppableCivilian" {
            
            collisionBetween(entityOne: contact.bodyB.node!, entityTwo: contact.bodyA.node!)
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
            removeTutorialInfected()
            
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
            
        }
    }
    
    //    MARK: Update, Tap,
    
    
    
    
    //    MARK: Swipe and didMove
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            for node in self.nodes(at: location) {
                if node.name == "civilian" {
                    let animation = SKAction.animate(with: [heal1, heal2, heal3, heal4, heal5], timePerFrame: 0.075)
                    
                    node.run(animation, completion: {
                        node.removeFromParent()
                        self.tutorialInfected()
                    })
                    if UserDefaults.standard.bool(forKey: "soundSetting") == true {
                        self.run(SoundFX.healing)
                    }
                    
                    if self.civilianIndex == 16 {
                        self.civilianIndex = 0
                    } else {
                        self.civilianIndex += 1
                    }
                }  else if node.name == "infectedCivilian" {
                    node.removeFromParent()
                    crowdAsses()
                    crowdZ += 1
                    createCrowd()
                    crowdZ += 1
                    crowdAsses()
                    createCrowd()
                    //                    powerLabel()
                }  else if node.name == "backgroundCivilian" {
                    node.removeFromParent()
                } else if node.name == "backButton" {
                    if view != nil {
                        let scene : SKScene = MainMenu(size: (view?.bounds.size)!)
                        let transition: SKTransition = SKTransition.fade(withDuration: 1)
                        self.view?.presentScene(scene, transition: transition)
                    }
                } else if node.name == "powerRemoveCrowd" {
                    if powerIndex == 10 {
                        
                        for child in self.children {
                            let animation = SKAction.animate(with: [heal1 ,heal2, heal3, heal4, heal5], timePerFrame: 0.075)
                            if child.name == "crowd" {
                                child.run(SKAction.stop())
                                child.run(animation, completion: {
                                    child.removeFromParent()
                                } )
                            }
                            if child.name == "backgroundCrowd" {
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
                        endLabel()
                    }
                }
            }
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
        
        musicLevel = SKAudioNode(fileNamed: "levelMusic.mp3")
        musicLevel.autoplayLooped = true
        self.addChild(musicLevel)
        
        if UserDefaults.standard.bool(forKey: "musicVolume") == true {
            musicLevel.run(SKAction.changeVolume(to: 1, duration: 0))
        } else {
            musicLevel.run(SKAction.changeVolume(to: 0, duration: 0))
        }
        
        createPlayer()
        
        createCivilian()
        
        startingCrowd(i: 0.0, j: 0.0)
        
        createBackButton()
        
        saveCivilianLabel()
        
        superPowerActivate()
        
    }
}
