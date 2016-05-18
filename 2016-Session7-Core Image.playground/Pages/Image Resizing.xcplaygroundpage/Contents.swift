//: [Previous](@previous)

//: # Image Resizing
//: There is a good rundown of different ways to resize images
//: using built-in frameworks on [NSHipster](http://nshipster.com/image-resizing/)
//: Note that this method using `CoreImage` is the slowest

import UIKit

let mona = CIImage(image: UIImage(named: "monalisa.jpg")!)!

// Set up the filter
let filter = CIFilter(name: "CILanczosScaleTransform")!

// Customize effect using key-values
filter.setValue(mona, forKey: "inputImage")
filter.setValue(0.2, forKey: "inputScale")
filter.setValue(1.0, forKey: "inputAspectRatio")

// Create the output image
let outputImage = filter.valueForKey("outputImage") as! CIImage

outputImage

// Force `CoreImage` to use the GPU to process the image.
let context = CIContext(options: [kCIContextUseSoftwareRenderer: false])

// Create a `UIImage` from the context
let scaledImage = UIImage(CGImage: context.createCGImage(outputImage, fromRect: outputImage.extent))



//: [Next](@next)
