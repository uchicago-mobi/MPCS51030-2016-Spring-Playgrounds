//
//  BallScene.swift
//  HavingABallWithSpriteKit
//
//  Created by T. Andrew Binkowski on 5/22/16.
//  Copyright © 2016 The University of Chicago, Department of Computer Science. All rights reserved.
//

import UIKit
import SpriteKit

class BallScene: SKScene {

 override func didMoveToView(view: SKView) {
        // Ensure that the scene fits the window. Note: This does not ensure 
        // that everything will look good or fit appropriately.
        self.scaleMode = .AspectFill
  
        /* Setup your scene here */
        let myLabel = SKLabelNode()
        myLabel.text = "Ball Scene!"
        myLabel.fontSize = 64
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

}
