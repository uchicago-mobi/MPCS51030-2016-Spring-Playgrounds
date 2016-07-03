//
//  PinkViewController.swift
//  CustomTransitions
//
//  Created by T. Andrew Binkowski on 5/28/16.
//  Copyright © 2016 The University of Chicago, Department of Computer Science. All rights reserved.
//

import UIKit

class PinkViewController: UIViewController {
  
  /// The view controller we are transitioning back to
  var rootViewController: ViewController!
  
  //
  // MARK: - IBActions
  //
  @IBAction func tapClose(sender: UIButton) {
    self.dismissViewControllerAnimated(true, completion: nil)
    
  }
  
  
  @IBAction func panRecognized(sender: UIPanGestureRecognizer) {
    
    // Set the threshold for triggering the transition to be 50%
    let progress = sender.translationInView(self.view).y/self.view.frame.size.height
    print("Progress: \(progress*100)%")
    
    switch sender.state {
    case .Began:
      rootViewController.interactionController = UIPercentDrivenInteractiveTransition()
      self.dismissViewControllerAnimated(true, completion: nil)
    case .Changed:
      self.rootViewController.interactionController?.updateInteractiveTransition(progress)
    case .Ended:
      if progress >= 0.5 {
        self.rootViewController.interactionController?.finishInteractiveTransition()
      } else {
        self.rootViewController.interactionController?.cancelInteractiveTransition()
      }
      
      self.rootViewController.interactionController = nil
    default:
      self.rootViewController.interactionController?.cancelInteractiveTransition()
      self.rootViewController.interactionController = nil
    }
    
  }
  
  //
  // MARK: - Lifecycle
  //
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    print("view did appear: Pink")
  }
  
}
