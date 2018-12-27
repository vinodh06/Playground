//: Playground - noun: a place where people can play

import UIKit

let image = CIImage(image: UIImage(named: "apple.png")!)!

struct GaussianBlur {
    var filter: CIFilter
    init(inputImage: CIImage, radius: Double) {
        filter = CIFilter(name: "CIGaussianBlur", withInputParameters: [
            kCIInputImageKey: inputImage,
            kCIInputRadiusKey: radius
            ])!
    }
}


/*extension GaussianBlur {
    var inputImage: CIImage {
        get { return filter.value(forKey: kCIInputImageKey) as! CIImage }
        set { filter.setValue(newValue, forKey: kCIInputImageKey) }
    }
    var radius: Double {
        get { return filter.value(forKey: kCIInputRadiusKey) as! Double }
        set { filter.setValue(newValue, forKey: kCIInputRadiusKey) }
    }
}
 */


/*:
 # Copy-On-Write
 
 One of the most powerful features of Swift is implementing structs with value semantics using mutable objects under the hood, which is exactly what we tried in the previous section. We get the benefits of value semantics, but we still have highly efficient code. However, as we have seen, this can lead to unwanted sharing. The approach we take in this section is to prevent sharing by copying the wrapped object every time the struct gets modified. This technique is called copy-on-write, and it is also how many of Swift’s data structures work. In order to implement copy-on-write, we can use a nice trick and define a custom accessor for filter, which copies the CIFilter before returning:
 */

extension GaussianBlur {
    private var filterForWriting: CIFilter {
        mutating get {
            filter = filter.copy() as! CIFilter
            return filter
        }
    }
}
/*:
 This allows us to change the setters of our filter, which make a copy before changing the values:
 */

extension GaussianBlur {
    var inputImage: CIImage {
        get { return filter.value(forKey: kCIInputImageKey) as! CIImage }
        set {
            filterForWriting.setValue(newValue, forKey: kCIInputImageKey)
        }
    }
    var radius: Double {
        get { return filter.value(forKey: kCIInputRadiusKey) as! Double }
        set {
            filterForWriting.setValue(newValue, forKey: kCIInputRadiusKey)
        }
    }
}
/*:
 
 **Changing the filter always makes a copy**
 
 The approach above works as expected but comes at a performance cost: every time we change the filter, a new copy gets made, even if we only make in-place changes and don’t share the struct
 
 */


/*:
 # Copy-On-Write, Efficiently
 
 There is a function in Swift, isUniquelyReferencedNonObjC, which checks whether an instance of a class is uniquely referenced. We can use this to keep value semantics for the struct while avoiding unnecessary copies: only when the object is shared between multiple structs do we copy it before we modify the instance. Unfortunately, the isUniquelyReferencedNonObjC function only works with Swift objects, and CIFilter is an Objective-C class. To work around this, we create a simple wrapper type, Box, which wraps any type in a Swift class:
 */
final class Box<A> {
    var unbox: A
    init(_ value: A) { unbox = value }
}

/*:
 This function allows us to change our implementation. Instead of storing the filter directly, we store the boxed filter and turn filter into a computed property that takes care of the boxing and unboxing:
 */


private var boxedFilter: Box<CIFilter> = {
    let filter = CIFilter(name: "CIGaussianBlur",
                          withInputParameters: [:])!
    filter.setDefaults()
    return Box(filter)
}()

var filter: CIFilter {
    get { return boxedFilter.unbox }
    set { boxedFilter = Box(newValue) }
}
/*:
 There is another function, isUniquelyReferenced, which does not work on Objective-C types either; even though it accepts Objective-C types as input, it always returns false. Both functions share the same implementation, but they have different constraints[…]
 */


/*:
 # isKnownUniquelyReferenced(_:)
 checks only for strong references to the
  given object---if `object` has additional weak or unowned references, the
 result may still be `true`. Because weak and unowned references cannot be
  the only reference to an object, passing a weak or unowned reference as
  `object` always results in `false`.
 */

private var filterForWriting: CIFilter {
    get {
        if !isKnownUniquelyReferenced(&boxedFilter) {
            filter = filter.copy() as! CIFilter
        }
        return filter
    }
}

/*:
 This is exactly how Swift arrays work internally. When you create a new copy of an array, it is backed by the same data. Only once you start modifying one of the arrays will a copy of the buffer be made so that changes don’t affect the other array.
 
 We can verify this behavior by writing a few simple tests. First of all, if we create two structs that share the same properties, no copy is made:
 */

let blur = GaussianBlur(inputImage: image, radius: 10)
var blur2 = blur
assert(blur.filter === blur2.filter)

/*:
 When we change the radius of blur2, the filterForWriting implementation will detect that the filter object is shared. As a result, it will make a copy:
 */

blur2.radius = 25
assert(blur.filter !== blur2.filter)

/*:
 Finally, if we change blur2 again, its filter is already unique. Therefore, changing it once more will not make a new copy of the filter:
 */

var existingFilter = blur2
blur2.radius = 100
//existingFilter.radius = 5
assert(existingFilter.filter === blur2.filter)


