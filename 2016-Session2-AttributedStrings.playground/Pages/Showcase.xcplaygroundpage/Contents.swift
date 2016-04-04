//:
//: Attributed String Showcase
//: ==========================
//:

//: [Previous](@previous)

import UIKit

// Create an attributed string
var attributedString = NSMutableAttributedString()

// Create an attributed string with fancy text
attributedString = NSMutableAttributedString(string: "Fancy Hello World!", attributes: [NSFontAttributeName:UIFont(name: "ChalkboardSE-Regular", size: 50.0)!])

/*:
----
Attributed String Showcase
--------------------------
Note that attributed string attributes are cumulative.  They will persist on that string until you change/undo them.  For highlighting words for the homework assignment, you will need to reset the previously highlighted words to the default attributes.
*/

// Changing the font over a specified range defined by `NSRange`. ##
attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "AmericanTypewriter-Bold", size: 18.0)!, range: NSRange(location:0,length:5))


// Change font in range, stroke the letter and change color ##
attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "Georgia", size: 100.0)!, range: NSRange(location: 0, length: 1))


// Stroke the first letter in red
attributedString.addAttribute(NSStrokeColorAttributeName, value: UIColor.redColor(), range:  NSRange(location: 0, length: 4))
attributedString.addAttribute(NSStrokeWidthAttributeName, value: 2, range: NSRange(location: 0, length: 1))


// Change the background color
attributedString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.yellowColor(), range: NSRange(location: 0, length: attributedString.length))

//: [Next](@next)
