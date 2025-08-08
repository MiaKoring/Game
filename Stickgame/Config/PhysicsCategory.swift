//
//  PhysicsCategory.swift
//  Stickgame
//
//  Created by Mia Koring on 06.08.25.
//

struct PhysicsCategory {
    static let none: UInt32        = 0          // 0        = 0
    static let player: UInt32      = 1 << 0     // 1        = 1
    static let ground: UInt32      = 1 << 1     // 10       = 2
    static let obstacle: UInt32    = 1 << 2     // 100
    static let booster: UInt32     = 1 << 3     // 1000
}
