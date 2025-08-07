//
//  CGFloat.swift
//  Stickgame
//
//  Created by Mia Koring on 07.08.25.
//
import Foundation
extension CGFloat {
    /// Gibt -1.0, 0.0 oder 1.0 zurück, je nach Vorzeichen.
    var sign: CGFloat {
        if self > 0 { return 1.0 }
        if self < 0 { return -1.0 }
        return 0.0
    }
}
