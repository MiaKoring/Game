//
//  CGVector.swift
//  Stickgame
//
//  Created by Mia Koring on 07.08.25.
//
import Foundation

extension CGVector {
    /// Betrag (Länge) des Vektors.
    func length() -> CGFloat {
        return dx.sign * sqrt(dx * dx + dy * dy)
    }
}
