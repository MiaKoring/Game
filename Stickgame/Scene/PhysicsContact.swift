//
//  PhysicsDelegate.swift
//  Stickgame
//
//  Created by Mia Koring on 08.08.25.
//

import GameplayKit

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let sorted = sortBodys(a: contact.bodyA, b: contact.bodyB)
        print(sorted.a.categoryBitMask)
        print(sorted.b.categoryBitMask)
        if sorted.a.categoryBitMask == PhysicsCategory.player &&
            sorted.b.categoryBitMask == PhysicsCategory.booster {
            let playerVelo = player.physicsBody?.velocity ?? CGVector(dx: 0, dy: 0)
            player.physicsBody?.velocity = CGVector(dx: playerVelo.dx * 2, dy: abs(playerVelo.dy) * 1.3)
            print("contact has been made")
        }
    }
    
    func sortBodys(a: SKPhysicsBody, b: SKPhysicsBody) -> (a: SKPhysicsBody, b: SKPhysicsBody) {
        if a.categoryBitMask < b.categoryBitMask {
            return (a: a, b: b)
        }
        return (a: b, b: a)
    }
}
