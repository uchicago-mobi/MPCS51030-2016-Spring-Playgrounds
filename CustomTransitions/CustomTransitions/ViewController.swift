//
//  ViewController.swift
//  CustomTransitions
//
//  Created by T. Andrew Binkowski on 5/28/16.
//  Copyright © 2016 The University of Chicago, Department of Computer Science. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  /// Monitor the percent of interaction
  var interactionController: UIPercentDrivenInteractiveTransition?
  
  /// The swift bird
  @IBOutlet weak var swiftImage: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    print("viewDidAppear")
  }
}


///
///
///
extension ViewController: UIViewControllerTransitioningDelegate {
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    segue.destinationViewController.transitioningDelegate = self
    (segue.destinationViewController as? PinkViewController)?.rootViewController = self
  }
  
  func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    print("Presented Controller")
    print(swiftImage.frame)
    return AnimationController(withDuration: 0.2, forTransitionType: .Dismissing, originFrame: swiftImage.frame)
  }
  
  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    print("Presented Controller")
    print(swiftImage.frame)
    return AnimationController(withDuration: 0.2, forTransitionType: .Presenting, originFrame: swiftImage.frame)
  }
  
  func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return self.interactionController
  }
  
  func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return nil
  }
}
