//: [Previous](@previous)

import UIKit

//: # Facial Dectection

//: # Face and detections
let mona = CIImage(image: UIImage(named: "monalisa.jpg")!)!
let faceImageView = UIImageView(image: UIImage(named: "monalisa.jpg"))
let faceDetector = CIDetector(ofType: CIDetectorTypeFace,context: nil,
                              options: [CIDetectorAccuracy: CIDetectorAccuracyHigh,
                                CIDetectorTracking: false,
                                CIDetectorMinFeatureSize: NSNumber(float: 0.1)])

// Find the features in the image
let faces = faceDetector.featuresInImage(mona,options: [CIDetectorEyeBlink: true, CIDetectorSmile: true])
if let face = faces.first as? CIFaceFeature {
  print("Found face at \(face.bounds)")
  if face.hasLeftEyePosition {
    print("Found left eye at \(face.leftEyePosition)")
  }
  
  if face.hasRightEyePosition {
    print("Found right eye at \(face.rightEyePosition)")
  }
  
  if face.hasMouthPosition {
    print("Found mouth at \(face.mouthPosition)")
  }
  
  // Answer an age old question
  face.hasSmile
}



//: # Show the face using a overlay
let originalImage = UIImage(named: "monalisa.jpg")!
let inputImage = CIImage(image: originalImage)!

// Get the original image and apply transfor to match Core Image coordiantes
// with UIKit coordinates
let inputImageSize = inputImage.extent.size
var transform = CGAffineTransformIdentity
transform = CGAffineTransformScale(transform, 1, -1)
transform = CGAffineTransformTranslate(transform, 0, -inputImageSize.height)

// Find the features in the image
for faceFeature in faceDetector.featuresInImage(mona) {
  if let face = faceFeature as? CIFaceFeature {
    var faceViewBounds = CGRectApplyAffineTransform(faceFeature.bounds, transform)
    
    // Determine the offset the bounds of the detected face to make them match UIKit coordinates
    let scale = min(faceImageView.bounds.size.width / inputImageSize.width,
                    faceImageView.bounds.size.height / inputImageSize.height)
    let offsetX = (faceImageView.bounds.size.width - inputImageSize.width * scale) / 2
    let offsetY = (faceImageView.bounds.size.height - inputImageSize.height * scale) / 2
    
    // Apply the transform and offset
    faceViewBounds = CGRectApplyAffineTransform(faceViewBounds, CGAffineTransformMakeScale(scale, scale))
    faceViewBounds.origin.x += offsetX
    faceViewBounds.origin.y += offsetY
    
    // Draw a box around the face
    let faceView = UIView(frame: faceViewBounds)
    faceView.layer.borderColor = UIColor.orangeColor().CGColor
    faceView.layer.borderWidth = 5
    faceImageView.addSubview(faceView)
    
    // Draw a red box around the left eye
    if face.hasLeftEyePosition {
      print("Found left eye at \(face.leftEyePosition)")

      // Create a dummy view that holds the original position. 
      // The 50,50 is just a guess at the bounding box size of the eye.
      var leftEyeView = UIView(frame: CGRectMake(0,0,50,50))
      leftEyeView.center = face.leftEyePosition
      
      // Apply the transform to account for coordinates
      var leftEyeViewBounds = CGRectApplyAffineTransform(leftEyeView.frame, transform)
      leftEyeViewBounds = CGRectApplyAffineTransform(leftEyeViewBounds, CGAffineTransformMakeScale(scale, scale))
      leftEyeViewBounds.origin.x += offsetX
      leftEyeViewBounds.origin.y += offsetY
      
      // Create a view to put over her eye
      var leftEyeViewAdjusted = UIView(frame: leftEyeViewBounds)
      leftEyeViewAdjusted.backgroundColor = UIColor.redColor()
      leftEyeViewAdjusted.alpha = 0.5
      faceImageView.addSubview(leftEyeViewAdjusted)
    }
  }
  
}

//: [Next](@next)
