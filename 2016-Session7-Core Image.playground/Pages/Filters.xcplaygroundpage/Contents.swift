//: [Previous](@previous)

//: # Core Image Filters

import UIKit
import CoreImage

//: List all the built-in filters
CIFilter.filterNamesInCategory(kCICategoryBuiltIn)

//: ### Filter Categories
kCICategoryHalftoneEffect
CIFilter.localizedNameForCategory(kCICategoryHalftoneEffect)


//: ### Querying for Filters
CIFilter.filterNamesInCategory(kCICategoryHalftoneEffect)
CIFilter.filterNamesInCategories([kCICategoryVideo,
    kCICategoryStillImage])

//: ### Using the Filter Name

CIFilter.localizedNameForFilterName("CICMYKHalftone")

CIFilter.localizedDescriptionForFilterName("CICMYKHalftone")

CIFilter(name: "xyz")

CIFilter(name: "CICMYKHalftone")

//: ### Interrogating the Filter

let filter = CIFilter(name: "CICMYKHalftone")!
let inputKeys = filter.inputKeys

filter.attributes.filter({ !inputKeys.contains($0.0) })

filter.attributes.filter({ inputKeys.contains($0.0) })

if let
    attribute = filter
        .attributes["inputGCR"] as? [String: AnyObject],
    minimum = attribute[kCIAttributeSliderMin] as? Float,
    maximum = attribute[kCIAttributeSliderMax] as? Float,
    defaultValue = attribute[kCIAttributeDefault] as? Float where
    (attribute[kCIAttributeClass] as? String) == "NSNumber"
{
    let slider = UISlider()
    
    slider.minimumValue = minimum
    slider.maximumValue = maximum
    slider.value = defaultValue
}

Set<String>(CIFilter.filterNamesInCategory(nil).flatMap {
    CIFilter(name: $0)!
        .attributes[kCIAttributeFilterCategories] as! [String]
    }).sort()

//: [Next](@next)
