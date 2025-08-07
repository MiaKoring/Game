//
//  SpriteViewRepresentable.swift
//  Stickgame
//
//  Created by Mia Koring on 07.08.25.
//

import SwiftUI
import SpriteKit

struct SpriteViewRepresentable: UIViewRepresentable {
    let sceneName = "GameScene"
    var zoom: CGFloat = 0.6

    func makeUIView(context: Context) -> SKView {
        let skView = SKView()

        skView.isMultipleTouchEnabled = true
        skView.isUserInteractionEnabled = true

        skView.showsFPS = true
        skView.showsNodeCount = true

        let scene: SKScene
        scene = GameScene.loadFromFile(named: sceneName)

        scene.scaleMode = .resizeFill
        if let game = scene as? GameScene {
            game.setZoom(zoom)
        }

        skView.presentScene(scene)

        return skView
    }

    func updateUIView(_ uiView: SKView, context: Context) {
        if let game = uiView.scene as? GameScene {
            game.setZoom(zoom)
        }
    }
}
