//
//  GameViewController.swift
//  TestGame
//
//  Created by Raffaele Siciliano on 07/02/22.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var gameScene : GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
        
        gameScene = GameScene()
        gameScene.sceneDelegate = self
        
        if let view = self.view as! SKView? {
            let scene = MainMenu(size: view.bounds.size)

            scene.scaleMode = .aspectFill
            
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
//            view.showsFPS = true
//            view.showsNodeCount = true
//            view.showsPhysics = true
            
        }
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// function that "localize" the String
extension String {
    func localized() -> String {
        return NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self
        )
    }
}

extension GameViewController: GameSceneDelegate {
    func gameWasPaused() {
        // Show your Label on top of your GameScene
    }
}

protocol GameSceneDelegate: AnyObject {
    func gameWasPaused()
}
