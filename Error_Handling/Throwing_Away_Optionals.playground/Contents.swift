//: Playground - noun: a place where people can play

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

func tint(_: UIImage, with: UIColor) throws -> UIImage {
    throw ImageError.failedToTint
}

func resize(_: UIImage, to: CGSize) throws -> UIImage {
    throw ImageError.failedToResize
}

func loadImageOptimized(named name: String,
               tintedWith color: UIColor,
               resizedTo size: CGSize) throws -> UIImage {
    var image = try loadImage(named: name)
    image = try tint(image, with: color)
    return try resize(image, to: size)
}

do {
    _ = try loadImageOptimized(named: "apple.png", tintedWith: UIColor.red, resizedTo: CGSize())
} catch {
    print(error)
}
/*
guard let userName = username, !userName.trimmingCharacters(in: .whitespaces).isEmpty else {
    self.vcProtocol.showErrorForUserName(message:"Username".localized())
    self.vcProtocol.animateActivityIndicator(isAnimate: false)
    return
}
// checks valid password
guard let password = password, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
    self.vcProtocol.showErrorForPassword(message: "Password".localized())
    self.vcProtocol.animateActivityIndicator(isAnimate: false)
    return
}
 */


