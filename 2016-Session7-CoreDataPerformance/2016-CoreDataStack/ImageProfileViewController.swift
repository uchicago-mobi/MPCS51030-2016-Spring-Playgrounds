//
//  ImageProfileViewController.swift
//  2016-CoreDataPeformance
//
//  Created by T. Andrew Binkowski on 5/9/16.
//  Copyright © 2016 The University of Chicago, Department of Computer Science. All rights reserved.
//

import UIKit

class ImageProfileViewController: UIViewController {

      @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var image3: UIImageView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        reload()
    }
    
    @IBAction func reload() {
        image1.image = nil
        image2.image = nil
        image3.image = nil
        
        loadSlowImage1()
        
        loadImage2()
        
        loadFastImage3()
    }
    
    func loadSlowImage1() {
        let url = NSURL(string: "http://logok.org/wp-content/uploads/2014/04/Apple-Logo-rainbow.png")
        if let path = url {
            let data = NSData(contentsOfURL: path)
            if let d = data {
                image1?.image = UIImage(data: d)
            }
        }
    }
    
    func loadImage2() {
        let path = NSBundle.mainBundle().pathForResource("logo", ofType: "jpg")!
        let img = UIImage(contentsOfFile: path)
        if let i = img {
            image2.image = i
        }
    }
    
    func loadFastImage3() {
        image3?.image = UIImage(named: "Logo")
    }


}
