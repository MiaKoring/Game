//
//  Main.swift
//  Stickgame
//
//  Created by Mia Koring on 07.08.25.
//

import Foundation
import SwiftUI
import SpriteKit

@main
struct Game: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var inputCommunicator = GameInput.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(inputCommunicator)
                .colorScheme(.light)
                
        }
    }
}

struct ContentView: View {
    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .overlay {
                    ZStack {
                        SpriteViewRepresentable(zoom: 0.6)
                            .ignoresSafeArea()
                        ControlsView()
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                            .ignoresSafeArea()
                    }
                }
        }
        
    }
}

struct ControlsView: View {
    @Environment(GameInput.self) var input
    var body: some View {
        @Bindable var input = input
        
        VStack {
            Spacer()
            HStack(spacing: 20) {
                GlassEffectContainer {
                    ControlButton(systemName: "chevron.left", pressed: $input.left)
                    ControlButton(systemName: "chevron.right", pressed: $input.right)
                }
                Spacer()
                ControlButton(systemName: "chevron.up") {
                    input.jump = true
                }
            }
        }
    }
    
    struct ControlButton: View {
        let systemName: String
        let controlWidth: CGFloat = 80
        var pressed: Binding<Bool>? = nil
        var onTap: (() -> Void)? = nil
        
        var body: some View {
            Button {
                onTap?()
            } label: {
                Circle()
                    .fill(.clear)
                    .overlay {
                        Image(systemName: systemName)
                            .font(.title)
                    }
                    .frame(width: controlWidth)
            }
            .contentShape(Circle())
            .glassEffect(.regular)
            .if (pressed != nil) { view in
                view
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                if !(pressed?.wrappedValue ?? true) {
                                    pressed?.wrappedValue = true
                                }
                            }
                            .onEnded { _ in
                                pressed?.wrappedValue = false
                            }
                        )
            }
        }
    }
}
#Preview {
    ContentView()
}
