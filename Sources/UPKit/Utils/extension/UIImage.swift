//
//  File.swift
//  
//
//  Created by Utsav Patel on 08/09/2024.
//

import UIKit

extension UIImage {
    public func drawAnotherImage(image: UIImage, on rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.size)
        let combinedImage = renderer.image { context in
            self.draw(in: CGRect(origin: .zero, size: self.size))
            image.draw(in: CGRect(origin: rect.origin, size: rect.size))
        }
        return combinedImage
    }
}
