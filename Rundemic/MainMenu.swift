//
//  MainMenu.swift
//  TestGame
//
//  Created by Raffaele Siciliano on 25/02/22.
//

import SpriteKit
import GameplayKit

class MainMenu: SKScene {
    
    var isTutorial = UserDefaults.standard.bool(forKey: "isTutorial")
    
    var playButton = SKSpriteNode(imageNamed: "start".localized())
    var settingsButton = SKSpriteNode(imageNamed: "settings")
    var logorundemic = SKSpriteNode(imageNamed: "Rundemic_logo")
    var crowdlogo = SKSpriteNode(imageNamed: "Crowd_logo")
    var chooseCharacterButton = SKSpriteNode()
    
    weak var sceneDelegate: GameSceneDelegate?
    
    var backgroundMusic = SKAudioNode()
    
    var barra = SKSpriteNode()
    var barradietro = SKSpriteNode()
    var resume = SKSpriteNode()
    var soundLabel = SKSpriteNode()
    var musicLabel = SKSpriteNode()
    var tutorial = SKSpriteNode()
    var creditLabel = SKSpriteNode()
    
    var isMusic : Bool = true
    var isSound : Bool = true
    
    var checkSound = SKSpriteNode()
    var checkSoundFill = SKSpriteNode()
    var checkMusic = SKSpriteNode()
    var checkMusicFill = SKSpriteNode()
    
    var creditBG = SKSpriteNode()
    var backCredit = SKSpriteNode()
    
    func moveBackground(image: [String], x: CGFloat, z:CGFloat, duration: Double, size: CGSize) {
        for i in 0...3 {
            
            let background = SKSpriteNode(imageNamed: image[i])
            background.anchorPoint = CGPoint.zero
            background.size = size
            background.position = CGPoint(x: x, y: size.height * CGFloat(i))
            background.zPosition = z
            
            let move = SKAction.moveBy(x: 0, y: -background.size.height*3, duration: 0)
            let back = SKAction.moveBy(x: 0, y: background.size.height*3, duration: duration)
            
            let sequence = SKAction.sequence([move, back])
            let repeatAction = SKAction.repeatForever(sequence)
            
            addChild(background)
            background.run(repeatAction)
            
        }
    }
    
    func musicTrue() {
        isMusic = true
        let userDefaults = UserDefaults.standard
        _ = userDefaults.bool(forKey: "musicVolume")
        userDefaults.set(true, forKey: "musicVolume")
        userDefaults.synchronize()
        
    }
    
    func musicFalse() {
        isMusic = false
        let userDefaults = UserDefaults.standard
        _ = userDefaults.bool(forKey: "musicVolume")
        userDefaults.set(false, forKey: "musicVolume")
        userDefaults.synchronize()
        
    }
    
    func soundTrue() {
        isSound = true
        let userDefaults = UserDefaults.standard
        _ = userDefaults.bool(forKey: "soundSetting")
        userDefaults.set(true, forKey: "soundSetting")
        userDefaults.synchronize()
        
    }
    
    func soundFalse() {
        isSound = false
        let userDefaults = UserDefaults.standard
        _ = userDefaults.bool(forKey: "soundSetting")
        userDefaults.set(false, forKey: "soundSetting")
        userDefaults.synchronize()
        
    }
    
    func startButton() {
        
        playButton.size = CGSize(width: 400, height: 150)
        playButton.position = CGPoint(x: frame.midX, y: crowdlogo.position.y - 230)
        playButton.zPosition = 1
        playButton.name = "playButton"
        addChild(playButton)
        
    }
    
    func menuEnvironment() {
        
        settingsButton.size = CGSize(width: 64, height: 64)
        settingsButton.position = CGPoint(x: frame.minX + 50, y: frame.maxY - 50)
        
        logorundemic.size = CGSize(width: self.size.width, height: 120)
        logorundemic.position = CGPoint(x: frame.midX, y: frame.midY + frame.midY / 2)
        
        crowdlogo.size = CGSize(width: 450, height: 400)
        crowdlogo.position = CGPoint(x: frame.midX, y: frame.midY - 40)
        
        chooseCharacterButton = SKSpriteNode(imageNamed: "chooseCharacter")
        chooseCharacterButton.size = CGSize(width: 64, height: 64)
        chooseCharacterButton.position = CGPoint(x: frame.maxX - 50, y: frame.maxY - 50)
        chooseCharacterButton.name = "choose"
        
        addChild(chooseCharacterButton)
        addChild(settingsButton)
        addChild(logorundemic)
        addChild(crowdlogo)
        
    }
    
    func settingsMenu() {
        
        sceneDelegate?.gameWasPaused()
        
        barra = SKSpriteNode(imageNamed: "option1")
        barradietro = SKSpriteNode()
        resume = SKSpriteNode(imageNamed: "close")
        soundLabel = SKSpriteNode(imageNamed: "soundLabel".localized())
        musicLabel = SKSpriteNode(imageNamed: "musicLabel".localized())
        tutorial = SKSpriteNode(imageNamed: "tutorialLabel")
        creditLabel = SKSpriteNode(imageNamed: "credits".localized())
        checkSound = SKSpriteNode(imageNamed: "checkEmpty")
        checkSoundFill = SKSpriteNode(imageNamed: "checkFill")
        checkMusicFill = SKSpriteNode(imageNamed: "checkFill")
        
        checkMusic = SKSpriteNode(imageNamed: "checkEmpty")
        
        barradietro.name = "sfondodietro"
        barradietro.zPosition = Layer.pauseGame
        barradietro.color = SKColor.black
        barradietro.size = CGSize(width: frame.maxX * 2, height: frame.maxY * 2)
        barradietro.position = CGPoint(x: frame.minX, y: frame.minY)
        barradietro.alpha = 0.5
        
        barra.name = "bar"
        barra.size = CGSize(width: 357, height: 475)
        barra.position = CGPoint(x: frame.midX, y: frame.midY)
        barra.zPosition = Layer.pauseBackground
        
        resume.name = "resume"
        resume.zPosition = Layer.pauseButtons
        resume.size = CGSize(width: 50, height: 50)
        resume.position = CGPoint(x: frame.midX + frame.midX / 1.5, y: frame.midY + frame.midY / 2.30)
        
        soundLabel.name = "soundLabel"
        soundLabel.zPosition = Layer.settingLabel
        soundLabel.size = CGSize(width: Int("154".localized())!, height: 36)
        soundLabel.position = CGPoint(x: frame.midX - frame.midX / 3, y: frame.midY + 110)
        
        checkSound.name = "checkSound"
        checkSound.zPosition = Layer.settingLabel
        checkSound.size = CGSize(width: 50, height: 50)
        checkSound.position = CGPoint(x: frame.midX + frame.midX / 2, y: frame.midY + 110)
        
        checkSoundFill.name = "checkSoundFill"
        checkSoundFill.zPosition = Layer.checkFill
        checkSoundFill.size = CGSize(width: 50, height: 50)
        checkSoundFill.position = CGPoint(x: frame.midX + frame.midX / 2, y: frame.midY + 110)
        checkSoundFill.alpha = 1
        
        musicLabel.name = "musicLabel"
        musicLabel.zPosition = Layer.settingLabel
        musicLabel.size = CGSize(width: Int("130".localized())!, height: 36)
        musicLabel.position = CGPoint(x: frame.midX - frame.midX / 3, y: frame.midY + 20)
        
        checkMusic.name = "checkMusic"
        checkMusic.zPosition = Layer.settingLabel
        checkMusic.size = CGSize(width: 50, height: 50)
        checkMusic.position = CGPoint(x: frame.midX + frame.midX / 2, y: frame.midY + 20)
        
        checkMusicFill.name = "checkMusicFill"
        checkMusicFill.zPosition = Layer.checkFill
        checkMusicFill.size = CGSize(width: 50, height: 50)
        checkMusicFill.position = CGPoint(x: frame.midX + frame.midX / 2, y: frame.midY + 20)
        checkMusicFill.alpha = 1
        
        tutorial.name = "tutorial"
        tutorial.zPosition = Layer.settingLabel
        tutorial.size = CGSize(width: 268, height: 61)
        tutorial.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        
        creditLabel.name = "credits"
        creditLabel.zPosition = Layer.settingLabel
        creditLabel.size = CGSize(width: 268, height: 61)
        creditLabel.position = CGPoint(x: frame.midX, y: frame.midY - 180)
        
        addChild(barradietro)
        addChild(barra)
        addChild(resume)
        addChild(soundLabel)
        addChild(checkSound)
        addChild(musicLabel)
        addChild(checkMusic)
        addChild(tutorial)
        addChild(creditLabel)
        addChild(checkSoundFill)
        addChild(checkMusicFill)
        
    }
    
    func credits() {
        creditBG = SKSpriteNode(imageNamed: "creditpage")
        backCredit = SKSpriteNode(imageNamed: "back")
        
        creditBG.name = "creditBG"
        creditBG.zPosition = Layer.pauseGame
        creditBG.color = SKColor.black
        creditBG.size = CGSize(width: frame.width, height: frame.height)
        creditBG.position = CGPoint(x: frame.midX, y: frame.midY)
        creditBG.alpha = 1
        
        backCredit.name = "backCredit"
        backCredit.zPosition = Layer.pauseButtons
        backCredit.size = CGSize(width: 64, height: 64)
        backCredit.position = CGPoint(x: frame.minX + 50, y: frame.maxY - 50)
        backCredit.alpha = 1
        
        addChild(creditBG)
        addChild(backCredit)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == playButton {
                
                if view != nil {
                    let userDefaults = UserDefaults.standard
                    if userDefaults.bool(forKey: "isTutorial") == false {
                        let scene : SKScene = Tutorial(size: (view?.bounds.size)!)
                        let transition: SKTransition = SKTransition.fade(withDuration: 1)
                        self.view?.presentScene(scene, transition: transition)
                    } else {
                        let scene : SKScene = GameScene(size: (view?.bounds.size)!)
                        let transition: SKTransition = SKTransition.fade(withDuration: 1)
                        self.view?.presentScene(scene, transition: transition)
                    }
                    
                }
                
            } else if node == settingsButton {
                
                settingsButton.removeFromParent()
                settingsMenu()
                
            } else if node.name == "choose" {
                
                let transition:SKTransition = SKTransition.fade(withDuration: 1)
                let scene : SKScene = ChooseCharacter(size: (view?.bounds.size)!)
                self.view?.presentScene(scene, transition: transition)
                
            } else if node.name == "resume" {
                
                barra.removeFromParent()
                barradietro.removeFromParent()
                resume.removeFromParent()
                soundLabel.removeFromParent()
                musicLabel.removeFromParent()
                tutorial.removeFromParent()
                creditLabel.removeFromParent()
                checkSound.removeFromParent()
                checkMusic.removeFromParent()
                checkSoundFill.removeFromParent()
                checkMusicFill.removeFromParent()
                
                addChild(settingsButton)
                
            } else if node.name == "checkMusic" {
                if UserDefaults.standard.bool(forKey: "musicVolume") == true {
                    musicFalse()
                    backgroundMusic.run(SKAction.changeVolume(to: 0, duration: 0))
                } else {
                    musicTrue()
                    backgroundMusic.run(SKAction.changeVolume(to: 1, duration: 0))
                }
            } else if node.name == "checkMusicFill" {
                if UserDefaults.standard.bool(forKey: "musicVolume") == true {
                    musicFalse()
                    backgroundMusic.run(SKAction.changeVolume(to: 0, duration: 0))
                } else {
                    musicTrue()
                    backgroundMusic.run(SKAction.changeVolume(to: 1, duration: 0))
                }
            } else if node.name == "checkSound" {
                if UserDefaults.standard.bool(forKey: "soundSetting") == true {
                    soundFalse()
                } else {
                    soundTrue()
                }
            } else if node.name == "checkSoundFill" {
                if UserDefaults.standard.bool(forKey: "soundSetting") == true {
                    soundFalse()
                } else {
                    soundTrue()
                }
            } else if node.name == "credits" {
                
                barra.removeFromParent()
                barradietro.removeFromParent()
                resume.removeFromParent()
                soundLabel.removeFromParent()
                musicLabel.removeFromParent()
                tutorial.removeFromParent()
                creditLabel.removeFromParent()
                checkSound.removeFromParent()
                checkMusic.removeFromParent()
                checkSoundFill.removeFromParent()
                checkMusicFill.removeFromParent()
                
                credits()
                
            } else if node.name == "backCredit" {
                backCredit.removeFromParent()
                creditBG.removeFromParent()
                settingsMenu()
            } else if node.name == "tutorial" {
                if view != nil {
                    let transition:SKTransition = SKTransition.fade(withDuration: 1)
                    let scene : SKScene = Tutorial(size: (view?.bounds.size)!)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if UserDefaults.standard.bool(forKey: "musicVolume") == true {
            checkMusicFill.alpha = 1
        } else {
            checkMusicFill.alpha = 0
        }
        if UserDefaults.standard.bool(forKey: "soundSetting") == true {
            checkSoundFill.alpha = 1
        } else {
            checkSoundFill.alpha = 0
        }
        
    }
    
    override func didMove(to view: SKView) {
        
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: "isTutorial") == nil { // 1
            userDefaults.set(false, forKey: "isTutorial") // 2
        }
        
        moveBackground(image: ["menuback1", "menuback2", "menuback3", "menuback1"], x: frame.minX, z: -3, duration: 8, size: CGSize(width: frame.width, height: frame.height))
        
        menuEnvironment()
        startButton()
        
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
