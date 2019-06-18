//
//  GameScene.swift
//  ios2d-Berzerk
//
//  Created by Parrot on 2019-06-12.
//  Copyright © 2019 Parrot. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // sprites
    var player:SKNode!
    var enemiesArray:[SKNode] = []
    var evilOtto:SKNode!
    
    
    
    override func didMove(to view: SKView) {
        // Required for SKPhysicsContactDelegate
        self.physicsWorld.contactDelegate = self
        
        // get the sprites from SceneKit Editor
        self.player = self.childNode(withName: "player")
        
        
        // make array of enemies
        let e1 = self.childNode(withName: "enemy1")
        let e2 = self.childNode(withName: "enemy2")
        let e3 = self.childNode(withName: "enemy3")
        let e4 = self.childNode(withName: "enemy4")
        self.enemiesArray.append(e1!)
        self.enemiesArray.append(e2!)
        self.enemiesArray.append(e3!)
        self.enemiesArray.append(e4!)
        
        // get evil Otto
        self.evilOtto = self.childNode(withName:"evilOtto")
        
    }
    
    // MARK: Function to notify us when two sprites touch
    func didBegin(_ contact: SKPhysicsContact) {
        
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        if (nodeA?.name == "player" && nodeB?.name == "exit") {
            print("Player reached exit")
            
            // GAME WIN!
            let messageLabel = SKLabelNode(text: "YOU WIN!")
            messageLabel.fontColor = UIColor.yellow
            messageLabel.fontSize = 60
            messageLabel.position.x = self.size.width/2
            messageLabel.position.y = self.size.height/2
            addChild(messageLabel)
        }
        
        if (nodeA?.name == "player" && nodeB?.name == "enemy1") {
            print("YOU LOSE!")
        }
        if (nodeA?.name == "player" && nodeB?.name == "enemy2") {
            print("YOU LOSE!")
        }
        if (nodeA?.name == "player" && nodeB?.name == "enemy3") {
            print("YOU LOSE!")
        }
        if (nodeA?.name == "player" && nodeB?.name == "enemy4") {
            print("YOU LOSE!")
        }
        
        
        
    }
    
    var timeOfLastUpdate:TimeInterval = -1;
    var evilOttoIsMoving:Bool = false
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        self.moveEnemy()
        
        
        // MARK: Deal with Evil Otto
        // -----------------------------
        // this code handles the first time you call the update() function
        if (timeOfLastUpdate == -1) {
            // First time, set timeOfLastUpdate
            // to current time
            timeOfLastUpdate = currentTime
        }
        
        let timePassed = currentTime - timeOfLastUpdate
        
        if (timePassed >= 5) {
            print("5 SECONDS PASSED!")
            timeOfLastUpdate = currentTime
            
            if (evilOttoIsMoving == false) {
                self.evilOttoIsMoving = true
            }
        }
        // ------ END TIME DETECTION -------------
        
        // MOVE EVIL OTTO
        if (self.evilOttoIsMoving == true) {
            evilOtto.position.x = evilOtto.position.x - 10
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        if (touch == nil) {
            return
        }
        
        let mouseLocation = touch!.location(in:self)
        let spriteTouched = self.atPoint(mouseLocation)
        
        
        if (spriteTouched.name == "up") {
            print("UP PRESSED")
            self.player.position.y = self.player.position.y + 30
        }
        else if (spriteTouched.name == "down") {
            print("DOWN PRESSED")
            self.player.position.y = self.player.position.y - 30
        }
        else if (spriteTouched.name == "left") {
            print("LEFT PRESSED")
            self.player.position.x = self.player.position.x - 30
        }
        else if (spriteTouched.name == "right") {
            print("RIGHT PRESSED")
            self.player.position.x = self.player.position.x + 30
        }
    }
    
    
    // MARK: Custom functions
    func moveEnemy() {
        // loop through all your enemy nodes
        // for each enemy node, do the vector math calculation
        for (i, enemy) in self.enemiesArray.enumerated() {
            //print("Moving enemy : \(i)")
            
            let a = self.player.position.x - enemy.position.x
            let b = self.player.position.y - enemy.position.y
            let d = sqrt(a*a + b*b)
            let xn = a / d
            let yn = b / d
            
            let ENEMY_SPEED:CGFloat = 2
            // update position
            enemy.position.x = enemy.position.x + xn * ENEMY_SPEED
            enemy.position.y = enemy.position.y + yn * ENEMY_SPEED
        }
    }
    
}
