//
//  GameScene.swift
//  HavingABallWithSpriteKit
//
//  Created by T. Andrew Binkowski on 5/22/16.
//  Copyright (c) 2016 The University of Chicago, Department of Computer Science. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  
  override func didMoveToView(view: SKView) {
    /* Setup your scene here */
    let myLabel = SKLabelNode(fontNamed:"Chalkduster")
    myLabel.text = "Hello, World!"
    myLabel.fontSize = 45
    myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
    
    self.addChild(myLabel)
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

    // Create a new ball scene from the scene file
    guard let ballScene = BallScene(fileNamed: "BallScene") else {
      print("Trouble creating ball scene")
      return
    }

    // Set the transition
    let transition = SKTransition.doorsOpenVerticalWithDuration(1.0)

    // Present it
    view?.presentScene(ballScene, transition: transition)
    
  }
  
  override func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
  }
}
