//
//  Input.swift
//  Stickgame
//
//  Created by Mia Koring on 07.08.25.
//

import SwiftUI

@Observable
final class GameInput {
    public static let shared = GameInput()
    
    var left = false
    var right = false
    
    var jump = false
    
    var reset = false
    
    private init() {}
}
