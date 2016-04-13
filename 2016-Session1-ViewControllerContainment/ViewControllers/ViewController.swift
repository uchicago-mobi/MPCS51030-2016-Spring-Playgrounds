//
//  ViewController.swift
//  ViewControllers
//
//  Created by T. Andrew Binkowski on 3/27/16.
//  Copyright © 2016 The University of Chicago, Department of Computer Science. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  
  @IBAction func tapAddRed(sender: UIBarButtonItem) {
  
    // Create instance of view controller and color it.
    let gvc = ColorViewController()
    gvc.delegate = self 
    gvc.view.backgroundColor = UIColor.redColor()

    // 1.
    addChildViewController(gvc)

    // 2.
    gvc.view.frame = CGRectMake(100, 100, 200, 200)
    view.addSubview(gvc.view)

    // 3.
    gvc.didMoveToParentViewController(self)
    
    
  }
  
  
  @IBAction func tapGreenButton(sender: UIBarButtonItem) {
    
    // Create a view controller and present it.  If the .xib file has the same
    // name, we don't need to explicity name it.
   
    
    let gvc = ColorViewController(nibName: "GreenViewController", bundle: nil)
    //let gvc = ColorViewController()
    gvc.view.backgroundColor = UIColor.greenColor()
    presentViewController(gvc, animated: true, completion: nil)

  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}

///
///
///
extension ViewController: ColorViewControllerDelegate {


  func removeFromContainerViewController(sender: ColorViewController) {
  
    // 1. Calls the child’s willMoveToParentViewController: method with a
    // parameter of nil to tell the child that it is being removed.
    sender.willMoveToParentViewController(nil)

    // 2. Clean up the view hierarchy
    sender.view.removeFromSuperview()

    // 3. Calls the child’s removeFromParentViewController method to remove it
    // from the container.
    sender.removeFromParentViewController()
    
  }
}




