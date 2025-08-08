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
    @FocusState private var focused: Bool
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
        .focusable()
        .focused($focused)
        .onKeyPress(phases: [.down, .up]) { press in
            print("key pressed")
            if press.phase == .down {
                switch press.key {
                case "a":
                    GameInput.shared.left = true
                case "d":
                    GameInput.shared.right = true
                case " ":
                    GameInput.shared.jump = true
                default: return .ignored
                }
                return .handled
            }
            
            switch press.key {
            case "a":
                GameInput.shared.left = false
            case "d":
                GameInput.shared.right = false
            default: return .ignored
            }
            return .handled
        }
        .onAppear {
            focused = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            focused = true
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
            Button {} label: {
                Circle()
                    .fill(.clear)
                    .overlay {
                        Image(systemName: systemName)
                            .font(.title)
                            .foregroundStyle(.black)
                    }
                    .frame(width: controlWidth)
            }
            .glassEffect(.regular)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if let pressed {
                            if !pressed.wrappedValue {
                                pressed.wrappedValue = true
                            }
                        } else {
                            onTap?()
                        }
                    }
                    .onEnded { _ in
                        pressed?.wrappedValue = false
                    }
                )
        }
    }
}
#Preview {
    ContentView()
}
