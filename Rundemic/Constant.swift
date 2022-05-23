//
//  Constant.swift
//  Rundemic
//
//  Created by Raffaele Siciliano on 19/02/22.
//

import SpriteKit

struct Size {
    static let characterWidth : Double = 56.25
    static let characterHeight : Double = 80
    static let crowdWidth: Double = 45
    static let crowdHeight: Double = 64
}

struct Layer {
    static let background: CGFloat = -3
    static let player: CGFloat = 1
    static let civilian: CGFloat = 2
    static let potion: CGFloat = 3
    static let score: CGFloat = 1999
    static let pauseGame: CGFloat = 2000
    static let pauseBackground: CGFloat = 2001
    static let pauseButtons: CGFloat = 2002
    static let settingLabel: CGFloat = 2003
    static let checkFill: CGFloat = 2004
}

struct PhysicsCategory {
    static let background: UInt32 = 0x1 << 0  // 1
    static let crowd: UInt32 = 0x1 << 2  // 2
    static let player: UInt32 = 0x1 << 4  // 4
    static let civilian: UInt32 = 0x1 << 6  // 8
    static let potion: UInt32 = 0x1 << 8
    static let infectedCivilian: UInt32 = 0x1 << 9
}

struct SoundFX {
    static let healing = SKAction.playSoundFileNamed("saveCivilian.mp3", waitForCompletion: false)
    static let darkras = SKAction.playSoundFileNamed("darkras.mp3", waitForCompletion: false)
    static let daveil = SKAction.playSoundFileNamed("daveil.mp3", waitForCompletion: false)
    static let derkin = SKAction.playSoundFileNamed("derkin.mp3", waitForCompletion: false)
    static let paskal = SKAction.playSoundFileNamed("paskal.mp3", waitForCompletion: false)
    static let perchy = SKAction.playSoundFileNamed("perchy.mp3", waitForCompletion: false)
    static let toneeno = SKAction.playSoundFileNamed("toneeno.mp3", waitForCompletion: false)
    static let potion = SKAction.playSoundFileNamed("potion.mp3", waitForCompletion: false)
}

extension SKColor {
    static let customYellow = SKColor(named: "customYellow")
    static let customGray = SKColor(named: "customGray")
}
