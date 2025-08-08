//
//  GameScene.swift
//  Stickgame
//
//  Created by Mia Koring on 06.08.25.
//

import SpriteKit
import GameplayKit

final class GameScene: SKScene {
    let input = GameInput.shared
    var scale: CGFloat = 0.6
    var left = false
    var right = false
    
    var player = SKNode()
    var playerBall = SKNode()
    var playerFace = SKNode()
    var controlsNode = SKNode()
    var startPos = SKNode()
    var velo1 = SKNode()
    
    var ground = SKNode()
    
    var isPlayerOnGround = false
    
    var playerMaxSpeed: CGFloat = 300
    
    var cameraNode = SKCameraNode()
    private let cameraLerp: CGFloat = 0.15
    var rollAnimationRunning = false
    
    private var lastUpdate: TimeInterval = 0
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { handleControlTouch(touches: touches)}
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { handleControlTouch(touches: touches, hasEnded: true)}
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { handleControlTouch(touches: touches, hasMoved: true) }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        view.ignoresSiblingOrder = true
        guard let playerContainer = childNode(withName: "playerContainer"),
            let playerBall = playerContainer.childNode(withName: "Player"),
            let playerFace = playerBall.childNode(withName: "face") else {
            fatalError("not all playernodes found")
        }
        player = playerContainer
        player.physicsBody = playerContainerPhysicsBody()
        self.playerBall = playerBall
        self.playerFace = playerFace
        
        if let node = childNode(withName: "Ground") {
            ground = node
        }
        
        if let node = childNode(withName: "Controls") {
            controlsNode = node
        }
        
        if let node = childNode(withName: "startPos") {
            startPos = node
        }
        
        if let node = childNode(withName: "velocityBooster") {
            velo1 = node
            
            let physicsBody = SKPhysicsBody(circleOfRadius: 40)
            physicsBody.collisionBitMask = 0
            physicsBody.categoryBitMask = PhysicsCategory.booster
            physicsBody.contactTestBitMask = PhysicsCategory.player
            physicsBody.friction = 0
            physicsBody.affectedByGravity = false
            print("booster configured")
            velo1.physicsBody = physicsBody
        }
        
        camera = cameraNode
        
        cameraNode.position = player.position
        cameraNode.setScale(1.0 / scale)
        
        setupGround()
    }
    
    private func setupGround() {
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        ground.physicsBody?.collisionBitMask = PhysicsCategory.player
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        updateCamPosition()
        
        let forceToApply = pow(playerMaxSpeed - (abs(player.physicsBody?.velocity.dx ?? 0)), 2)
        
        if input.left != input.right && abs(player.physicsBody?.velocity.dx ?? 0) < 200 {
            if input.left {
                player.physicsBody?.applyForce(CGVector(dx: -1 * forceToApply, dy: 0))
            }
            if input.right {
                player.physicsBody?.applyForce(CGVector(dx: forceToApply, dy: 0))
            }
        }
        
        if input.jump {
            jump()
            input.jump = false
        }
        
        if let speed = player.physicsBody?.velocity.length() {
            let angularSpeed = speed / 64.0
            let dt = deltaTime(currentTime)
            playerBall.zRotation += angularSpeed * dt * -1 //-1 to rotate according to direction of movement
            playerFace.zRotation += angularSpeed * dt // no -1 to rotate in the oposite direction of the ball
        }
    }
    
    private func updateCamPosition() {
        let pos = player.position
        let x = pos.x + size.width / (5 * scale)
        let y = pos.y + size.height / (4 * scale)
        
        let currentCamPos = cameraNode.position
        let newCamPos = CGPoint(
            x: currentCamPos.x + (x - currentCamPos.x) * cameraLerp,
            y: currentCamPos.y + (y - currentCamPos.y) * cameraLerp
        )
        cameraNode.position = newCamPos
        updateControlsPosition()
        
        func updateControlsPosition() {
            let pos = cameraNode.position
            let x = pos.x - 400
            let y = pos.y - 180
            controlsNode.position = CGPoint(x: x, y: y)
        }
    }
    
    private func jump() {
        guard abs(player.physicsBody?.velocity.dy ?? 1.0) < 0.1 else {
            print("player not grounded")
            return
        }
        player.physicsBody?.velocity.dy = 0
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 15000))
    }
    
    private func respawn() {
        player.position = startPos.position
        updateCamPosition()
    }
    
    private func handleControlTouch(touches: Set<UITouch>, hasEnded: Bool = false, hasMoved: Bool = false) {
        var leftTouched = false
        var rightTouched = false
        
        for touch in touches {
            let pos = touch.location(in: self)
            
            if let name = nodes(at: pos).first?.name?.lowercased() {
                switch name {
                case "left":
                    leftTouched = true
                case "right":
                    rightTouched = true
                case "jump":
                    if !hasEnded {
                        jump()
                    }
                case "respawn":
                    if !hasEnded && !hasMoved {
                        respawn()
                    }
                default: break
                }
            }
        }
        
        if hasEnded && leftTouched {
            left = false
        }
        if hasEnded && rightTouched {
            right = false
        }
        if !hasEnded && !hasMoved && leftTouched {
            left = true
        }
        if !hasEnded && !hasMoved && rightTouched {
            right = true
        }
        if hasMoved {
            left = leftTouched
            right = rightTouched
        }
    }
    
    private func playerContainerPhysicsBody() -> SKPhysicsBody {
        let physicsBody = SKPhysicsBody(circleOfRadius: 64)
        physicsBody.categoryBitMask = PhysicsCategory.player
        physicsBody.contactTestBitMask = PhysicsCategory.booster
        physicsBody.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.obstacle
        physicsBody.fieldBitMask = 4294967295
        physicsBody.allowsRotation = false
        physicsBody.friction = 0.2
        physicsBody.linearDamping = 0.1
        physicsBody.angularDamping = 0.1
        physicsBody.restitution = 0
        physicsBody.mass = 25
        
        return physicsBody
    }
    
    private func deltaTime(_ now: TimeInterval) -> CGFloat {
        defer { lastUpdate = now }
        let dt = now - lastUpdate
        return CGFloat(dt > 0 ? dt : 0)
    }
    
    static func loadFromFile(named name: String) -> GameScene {
        if let scene = SKScene(fileNamed: name) as? GameScene {
            return scene
        } else {
            // If the .sks fails to cast or is missing, create a blank scene
            let scene = GameScene(size: CGSize(width: 800, height: 600))
            scene.scaleMode = .resizeFill
            print("failed to load Scene")
            return scene
        }
    }
    
    public func setZoom(_ zoom: CGFloat) {
        self.scale = zoom
    }
}

