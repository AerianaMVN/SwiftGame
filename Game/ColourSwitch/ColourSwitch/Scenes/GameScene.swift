//
//  GameScene.swift
//  ColourSwitch
//
//  Created by Aeriana Narbonne on 2021-02-16.
//  Copyright © 2021 Aeriana Narbonne. All rights reserved.
//

import SpriteKit
//import GameplayKit

enum PlayColors{
    static let colors = [
        UIColor(red: 231/255, green: 7/255, blue: 6/255, alpha: 1.0),
        UIColor(red: 21/255, green: 76/255, blue: 6/255, alpha: 1.0),
        UIColor(red: 3/255, green: 6/255, blue: 60/255, alpha: 1.0),
        UIColor(red: 91/255, green: 72/255, blue: 60/255, alpha: 1.0)

    ]
}

enum SwitchState : Int {
    case red, yellow, green, blue
}

class GameScene: SKScene {
    var colourSwitch : SKSpriteNode!
    var switchState = SwitchState.red
    var currentColorIndex: Int?
    
    override func didMove(to view: SKView) {
        setupPhysics()
        layoutScene()
    }
    
    func setupPhysics(){
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        physicsWorld.contactDelegate = self
    }
    
    func layoutScene(){
        backgroundColor = UIColor(red: 5/255, green: 2/255, blue: 8/255, alpha: 1.0)
        colourSwitch = SKSpriteNode(imageNamed: "ColourCircle")
        colourSwitch.size = CGSize(width: frame.width/3, height:
            frame.size.width/3)
        colourSwitch.position = CGPoint(x: frame.midX, y: frame.minY +
            colourSwitch.size.height)
        colourSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colourSwitch.size.width/2)
        colourSwitch.physicsBody?.categoryBitMask =
            PhysicsCategories.switchCategory
        colourSwitch.physicsBody?.isDynamic = false
        addChild(colourSwitch)
        
        spawnBall()
    }
 
    func spawnBall(){
        currentColorIndex = Int(arc4random_uniform(UInt32(4))) // no ?
        
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColors.colors[currentColorIndex!], size: CGSize(width: 30.0, height: 30.0))
        ball.colorBlendFactor = 1.0
        ball.name = "Ball"
        ball.position = CGPoint(x: frame.midX, y: frame.maxY)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none
        addChild(ball)
    }
    
    func turnWheel(){
        if let newState = SwitchState(rawValue: switchState.rawValue + 1){
            switchState = newState
        }else{
            switchState = .red
        }
        
        colourSwitch.run(SKAction.rotate(byAngle:.pi/2 , duration: 0.25)) // colorSwitch
    }
    
    func gameOver(){
        print("Game Over!")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        turnWheel()
    }
    
}
 

extension GameScene: SKPhysicsContactDelegate{
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask |
            contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.ballCategory |
            PhysicsCategories.switchCategory {
                if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node
                    as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode{
                    if currentColorIndex == switchState.rawValue { //==
                        print("Correct!")
                        ball.run(SKAction.fadeOut(withDuration: 0.25), completion: {
                            ball.removeFromParent()
                            self.spawnBall()
                        } )
                    } else {
                        gameOver()
                    }
            }
        }
    }

}






