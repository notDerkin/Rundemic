//
//  ChooseCharacter.swift
//  TestGame
//
//  Created by Raffaele Siciliano on 02/03/22.
//

import SpriteKit

class ChooseCharacter: SKScene {
    
    var backgroundMusic = SKAudioNode()
    
    var backButton = SKSpriteNode()
    
    var text1 = ""
    var text2 = ""
    var chosenOne = "Perchy_0"
    var chosenName = "Perchy_Name"
    
    var playerOne = SKSpriteNode()
    var playerTwo = SKSpriteNode()
    var playerThree = SKSpriteNode()
    var playerFour = SKSpriteNode()
    var playerFive = SKSpriteNode()
    var playerSix = SKSpriteNode()
    var confirmButton = SKSpriteNode()
    var shadow = SKSpriteNode()
    var characterImage = SKSpriteNode()
    var characterName = SKSpriteNode()
    
    var isSound = UserDefaults.standard.bool(forKey: "isSound")
    
    func changeSkin() {
        let userDefaults = UserDefaults.standard
        var textureOne = userDefaults.string(forKey: "textureOne")
        var textureTwo = userDefaults.string(forKey: "textureTwo")
        var chosen = userDefaults.string(forKey: "chosen")
        var selectedName = userDefaults.string(forKey: "selectedName")
        
        textureOne = self.text1
        userDefaults.set(textureOne, forKey: "textureOne")
        textureTwo = self.text2
        userDefaults.set(textureTwo, forKey: "textureTwo")
        chosen = self.chosenOne
        userDefaults.set(chosen, forKey: "chosen")
        selectedName = self.chosenName
        userDefaults.set(selectedName, forKey: "selectedName")
        userDefaults.synchronize()
        print(textureOne!)
        print(textureTwo!)
        print(chosen!)
        print(selectedName!)
        
    }
    
    func changeCharacterScreen() {
        backgroundColor = SKColor.customGray!
        backButton = SKSpriteNode(imageNamed: "back")
        
        backButton.name = "backButton"
        backButton.zPosition = Layer.pauseGame
        backButton.size = CGSize(width: 64, height: 64)
        backButton.position = CGPoint(x: frame.minX + 50, y: frame.maxY - 50)
        backButton.alpha = 1
        
        playerOne = SKSpriteNode(imageNamed: "Daveil_Face")
        playerOne.name = "playerOne"
        playerOne.position = CGPoint(x: frame.midX - 130, y: frame.midY - 170)
        playerOne.zPosition = Layer.player
        playerOne.size = CGSize(width: 100, height: 100)
        
        playerTwo = SKSpriteNode(imageNamed: "Perchy_Face")
        playerTwo.name = "playerTwo"
        playerTwo.position = CGPoint(x: frame.midX, y: frame.midY - 170)
        playerTwo.zPosition = Layer.player
        playerTwo.size = CGSize(width: 100, height: 100)
        
        playerThree = SKSpriteNode(imageNamed: "Toneeno_Face")
        playerThree.name = "playerThree"
        playerThree.position = CGPoint(x: frame.midX + 130, y: frame.midY - 170)
        playerThree.zPosition = Layer.player
        playerThree.size = CGSize(width: 100, height: 100)
        
        
        playerFour = SKSpriteNode(imageNamed: "Darkras_Face")
        playerFour.name = "playerFour"
        playerFour.position = CGPoint(x: frame.midX - 130, y: frame.midY - 270)
        playerFour.zPosition = Layer.player
        playerFour.size = CGSize(width: 100, height: 100)
        
        playerFive = SKSpriteNode(imageNamed: "Paskal_Face")
        playerFive.name = "playerFive"
        playerFive.position = CGPoint(x: frame.midX, y: frame.midY - 270)
        playerFive.zPosition = Layer.player
        playerFive.size = CGSize(width: 100, height: 100)
        
        playerSix = SKSpriteNode(imageNamed: "Derkin_Face")
        playerSix.name = "playerSix"
        playerSix.position = CGPoint(x: frame.midX + 130, y: frame.midY - 270)
        playerSix.zPosition = Layer.player
        playerSix.size = CGSize(width: 100, height: 100)
        
        confirmButton = SKSpriteNode(imageNamed: "confirm".localized())
        confirmButton.name = "confirmButton"
        confirmButton.position = CGPoint(x: frame.midX, y: frame.midY - 370)
        confirmButton.zPosition = Layer.player
        confirmButton.size = CGSize(width: 290, height: 61)
        
        shadow = SKSpriteNode(imageNamed: "shadow")
        shadow.name = "shadow"
        shadow.position = CGPoint(x: frame.midX, y: frame.midY - 80)
        shadow.zPosition = Layer.player
        shadow.size = CGSize(width: 211, height: 57)
        
        addChild(backButton)
        addChild(playerOne)
        addChild(playerTwo)
        addChild(playerThree)
        addChild(playerFour)
        addChild(playerFive)
        addChild(playerSix)
        addChild(confirmButton)
        addChild(shadow)
    }
    
    func removeCharacterDisplay() {
        characterImage.removeFromParent()
        characterName.removeFromParent()
    }
    
    func characterDisplay() {
        
        let chosen = UserDefaults.standard.string(forKey: "chosen")
        characterImage = SKSpriteNode(imageNamed: chosen ?? chosenOne)
        characterImage.texture = SKTexture(imageNamed: chosen ?? "Perchy_0")
        characterImage.name = "characterImage"
        characterImage.position = CGPoint(x: frame.midX, y: frame.midY + 95)
        characterImage.zPosition = Layer.pauseGame
        characterImage.size = CGSize(width: 240, height: 341.33)
        
        let selectedName = UserDefaults.standard.string(forKey: "selectedName")
        characterName = SKSpriteNode(imageNamed: selectedName ?? chosenName)
        characterName.name = "characterName"
        characterName.position = CGPoint(x: frame.midX, y: frame.midY + 310)
        characterName.zPosition = Layer.pauseGame
        characterName.size = CGSize(width: 306.9, height: 100)
        
        addChild(characterImage)
        addChild(characterName)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            if node.name == "backButton" {
                
                let transition:SKTransition = SKTransition.fade(withDuration: 1)
                let scene : SKScene = MainMenu(size: (view?.bounds.size)!)
                self.view?.presentScene(scene, transition: transition)
                
            } else if node.name == "playerOne" {
                
                text1 = "Daveil_1"
                text2 = "Daveil_2"
                chosenOne = "Daveil_0"
                chosenName = "Daveil_Name"
                changeSkin()
                if UserDefaults.standard.bool(forKey: "soundSetting") == true {
                    self.run(SoundFX.daveil)
                }
                removeCharacterDisplay()
                characterDisplay()
                
            } else if node.name == "playerTwo" {
                
                text1 = "Perchy_1"
                text2 = "Perchy_2"
                chosenOne = "Perchy_0"
                chosenName = "Perchy_Name"
                changeSkin()
                if UserDefaults.standard.bool(forKey: "soundSetting") == true {
                    self.run(SoundFX.perchy)
                }
                removeCharacterDisplay()
                characterDisplay()
                
            }  else if node.name == "playerThree" {
                
                text1 = "Toneeno_1"
                text2 = "Toneeno_2"
                chosenOne = "Toneeno_0"
                chosenName = "Toneeno_Name"
                changeSkin()
                if UserDefaults.standard.bool(forKey: "soundSetting") == true {
                    self.run(SoundFX.toneeno)
                }
                removeCharacterDisplay()
                characterDisplay()
                
            } else if node.name == "playerFour" {
                
                text1 = "Darkras_1"
                text2 = "Darkras_2"
                chosenOne = "Darkras_0"
                chosenName = "Darkras_Name"
                changeSkin()
                if UserDefaults.standard.bool(forKey: "soundSetting") == true {
                    self.run(SoundFX.darkras)
                }
                removeCharacterDisplay()
                characterDisplay()
                
            } else if node.name == "playerFive" {
                
                text1 = "Paskal_1"
                text2 = "Paskal_2"
                chosenOne = "Paskal_0"
                chosenName = "Paskal_Name"
                changeSkin()
                if UserDefaults.standard.bool(forKey: "soundSetting") == true {
                    self.run(SoundFX.paskal)
                }
                removeCharacterDisplay()
                characterDisplay()
                
            } else if node.name == "playerSix" {
                
                text1 = "Derkin_1"
                text2 = "Derkin_2"
                chosenOne = "Derkin_0"
                chosenName = "Derkin_Name"
                changeSkin()
                if UserDefaults.standard.bool(forKey: "soundSetting") == true {
                    self.run(SoundFX.derkin)
                }
                removeCharacterDisplay()
                characterDisplay()
                
            } else if node.name == "confirmButton" {
                UserDefaults.standard.synchronize()
                let transition:SKTransition = SKTransition.fade(withDuration: 1)
                let scene : SKScene = MainMenu(size: (view?.bounds.size)!)
                self.view?.presentScene(scene, transition: transition)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if UserDefaults.standard.string(forKey: "textureOne") == "Daveil_1" {
            playerOne.alpha = 1
            playerTwo.alpha = 0.4
            playerThree.alpha = 0.4
            playerFour.alpha = 0.4
            playerFive.alpha = 0.4
            playerSix.alpha = 0.4
        } else if UserDefaults.standard.string(forKey: "textureOne") == "Perchy_1" {
            playerOne.alpha = 0.4
            playerTwo.alpha = 1
            playerThree.alpha = 0.4
            playerFour.alpha = 0.4
            playerFive.alpha = 0.4
            playerSix.alpha = 0.4
        } else if UserDefaults.standard.string(forKey: "textureOne") == "Toneeno_1" {
            playerOne.alpha = 0.4
            playerTwo.alpha = 0.4
            playerThree.alpha = 1
            playerFour.alpha = 0.4
            playerFive.alpha = 0.4
            playerSix.alpha = 0.4
        } else if UserDefaults.standard.string(forKey: "textureOne") == "Darkras_1" {
            playerOne.alpha = 0.4
            playerTwo.alpha = 0.4
            playerThree.alpha = 0.4
            playerFour.alpha = 1
            playerFive.alpha = 0.4
            playerSix.alpha = 0.4
        } else if UserDefaults.standard.string(forKey: "textureOne") == "Paskal_1" {
            playerOne.alpha = 0.4
            playerTwo.alpha = 0.4
            playerThree.alpha = 0.4
            playerFour.alpha = 0.4
            playerFive.alpha = 1
            playerSix.alpha = 0.4
        } else if UserDefaults.standard.string(forKey: "textureOne") == "Derkin_1" {
            playerOne.alpha = 0.4
            playerTwo.alpha = 0.4
            playerThree.alpha = 0.4
            playerFour.alpha = 0.4
            playerFive.alpha = 0.4
            playerSix.alpha = 1
        }
        
    }
    
    override func didMove(to view: SKView) {
        
        changeCharacterScreen()
        
        characterDisplay()
        
        //        ## COPYRIGHT FOR THE AUTHOR
        //        Link: https://www.youtube.com/watch?v=O7SauPM0oxg
        //        Creator: Matt Production
        
        backgroundMusic = SKAudioNode(fileNamed: "mainMenu.mp3")
        backgroundMusic.autoplayLooped = true
        self.addChild(backgroundMusic)
        
        if UserDefaults.standard.bool(forKey: "musicVolume") == true {
            backgroundMusic.run(SKAction.changeVolume(to: 1, duration: 0))
        } else {
            backgroundMusic.run(SKAction.changeVolume(to: 0, duration: 0))
        }
        
    }
    
}
