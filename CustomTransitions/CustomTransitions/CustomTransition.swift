//
//  CustomTransition.swift
//  CustomTransitions
//
//  Created by T. Andrew Binkowski on 5/28/16.
//  Copyright © 2016 The University of Chicago, Department of Computer Science. All rights reserved.
//

import Foundation
import UIKit

/// Define the types we want to use the custom transition on
enum TransitionType {
  case Presenting, Dismissing
}


class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
  //
  // MARK: - Class variables
  //
  
  /// How long is the transition
  var duration: NSTimeInterval
  /// Is the ViewController the presenting controller
  var isPresenting: Bool
  // How big do we want the frame to be
  var originFrame: CGRect
  
  
  init(withDuration duration: NSTimeInterval, forTransitionType type: TransitionType, originFrame: CGRect) {
    self.duration = duration
    self.isPresenting = type == .Presenting
    self.originFrame = originFrame
    
    super.init()
  }
  
  //
  // MARK: - 
  //
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return self.duration
  }
  

  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView()!
    
    // Get the from and to views
    let fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!.view
    let toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!.view
    
    // Determine which way the transition is going
    let detailView = self.isPresenting ? toView : fromView
    
    // Put the toView on top if presenting
    if self.isPresenting {
      containerView.addSubview(toView)
    } else {
      containerView.insertSubview(toView, belowSubview: fromView)
    }
    
    // Match the frame size and fade in
    detailView.frame.origin = self.isPresenting ? self.originFrame.origin : CGPoint(x: 0, y: 0)
    detailView.frame.size.width = self.isPresenting ? self.originFrame.size.width : containerView.bounds.width
    detailView.layoutIfNeeded()
    
    for view in detailView.subviews {
      if !(view is UIImageView) {
        view.alpha = isPresenting ? 0.0 : 1.0
      }
    }
    
    UIView.animateWithDuration(self.duration, animations: { () -> Void in
      detailView.frame = self.isPresenting ? containerView.bounds : self.originFrame
      detailView.layoutIfNeeded()
      
      for view in detailView.subviews {
        if !(view is UIImageView) {
          view.alpha = self.isPresenting ? 1.0 : 0.0
        }
      }
    }) { (completed: Bool) -> Void in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
    }
  }
}

