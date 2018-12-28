
import UIKit


func loadImage(named name: String,
               tintedWith color: UIColor,
               resizedTo size: CGSize) -> UIImage? {
    guard let baseImage = UIImage(named: name) else {
        return nil
    }
    /*
    guard let tintedImage = tint(img: baseImage, with: color) else {
        return nil
    }
    
    return resize(tintedImage, to: size)
    */
    return baseImage
}

enum ImageError: Error {
    case missing
    case failedToTint
    case failedToResize
}


private func loadImage(named name: String) throws -> UIImage {
    guard let image = UIImage(named: name) else {
        throw ImageError.missing
    }
    
    return image
}

func tint(image img: UIImage, with: UIColor) throws -> UIImage {
    return img
}

func resize(_: UIImage, to: CGSize) throws -> UIImage {
    throw ImageError.failedToResize
}

func loadImageOptimized(named name: String,
               tintedWith color: UIColor,
               resizedTo size: CGSize) throws -> UIImage {
    var image = try loadImage(named: name)
    image = try tint(image: image, with: color)
    return try resize(image, to: size)
}

do {
    _ = try loadImageOptimized(named: "apple2.png", tintedWith: UIColor.red, resizedTo: CGSize())
} catch {
    print(error)
}


