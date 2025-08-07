//
//  View.swift
//  Stickgame
//
//  Created by Mia Koring on 07.08.25.
//
import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        _ `if`: (Self) -> Content
    ) -> some View {
        if condition {
            `if`(self)
        } else {
            self
        }
    }
}
