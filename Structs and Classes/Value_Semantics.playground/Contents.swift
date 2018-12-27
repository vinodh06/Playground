//: Playground - noun: a place where people can play

import UIKit

/*:
 # Value Types

Value types imply that whenever a variable is copied, the value itself — and not just a reference to the value — is copied.
*/

var a = 42
var b = a
b += 1
print(a)
print(b)


/*:
 Objects are always passed by reference. Therefore, the variable secondBlurFilter points to the same instance of CIFilter: they are both a reference to the same object.Demo with **The CIFilter** class
 */
let image = CIImage(image: UIImage(named: "apple.png")!)!

let inputParameters = [
    kCIInputRadiusKey: 10,
    kCIInputImageKey: image
    ] as [String : Any]
let blurFilter = CIFilter(name: "CIGaussianBlur",
                          withInputParameters: inputParameters)!
let secondBlurFilter = blurFilter
secondBlurFilter.setValue(20, forKey: kCIInputRadiusKey)
print(blurFilter)
print(secondBlurFilter)


/*:
In Swift, both structs and enums are value types. We could create our own GaussianBlur struct, where we save the input image and radius in a variable:
*/

struct GaussianBlurOld {
    var inputImage: CIImage
    var radius: Double
}
var blur1 = GaussianBlurOld(inputImage: image, radius: 10)
blur1.radius = 20
var blur2 = blur1
blur2.radius = 30

extension GaussianBlurOld {
    var outputImage: CIImage {
        let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: [
            kCIInputImageKey: inputImage,
            kCIInputRadiusKey: radius
            ])!
        return filter.outputImage!
    }
}
/*:
 More Efficent Method
 
 Instead of storing the values in the struct, we store an instance of CIFilter and modify that through custom properties. We declare the filter as a var because we will need this later on:
 */

struct GaussianBlur {
    private var filter: CIFilter
    init(inputImage: CIImage, radius: Double) {
        filter = CIFilter(name: "CIGaussianBlur", withInputParameters: [
            kCIInputImageKey: inputImage,
            kCIInputRadiusKey: radius
            ])!
    }
}


extension GaussianBlur {
    var inputImage: CIImage {
        get { return filter.value(forKey: kCIInputImageKey) as! CIImage }
        set { filter.setValue(newValue, forKey: kCIInputImageKey) }
    }
    var radius: Double {
        get { return filter.value(forKey: kCIInputRadiusKey) as! Double }
        set { filter.setValue(newValue, forKey: kCIInputRadiusKey) }
    }
}


/*:
Finally, to get the output image out, we can directly use the outputImage property on the filter:
*/

extension GaussianBlur {
    var outputImage: CIImage {
        return filter.outputImage!
    }
}

var blur = GaussianBlur(inputImage: image, radius: 25)
blur.outputImage

/*:
However, once we start making copies of the struct, we will run into a problem:
 */

var otherBlur = blur
otherBlur.radius = 10

/*:
 References are shared between blur and otherBlur.Both the filter pointed to same address
 */


