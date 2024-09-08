//
//  UIColor.swift
//
//
//  Created by Utsav Patel on 08/09/2024.
//

import UIKit
import CoreGraphics

extension UIColor {
    public var inverted: UIColor {
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return UIColor(red: (1 - r), green: (1 - g), blue: (1 - b), alpha: a) // Assuming you want the same alpha value.
    }
    
    public var name: String {
        getName(for: self.cgColor)
    }
    
    func getName(for color: CGColor) -> String {
        guard let colorComponents = color.components else { fatalError("Could not find color components") }
        
        let red = Int(colorComponents[0] * 255)
        let green = Int(colorComponents[1] * 255)
        let blue = Int(colorComponents[2] * 255)
        
        let colorNames = ColorName.colors
        
        var selectedColor = colorNames[0]
        var priorDistance = Int.max
        
        for colorName in colorNames {
            
            let redDifference = abs(colorName.red - red)
            let greenDifference = abs(colorName.green - green)
            let blueDifference = abs(colorName.blue - blue)
            
            let distance = redDifference + greenDifference + blueDifference
            
            if priorDistance > distance {
                priorDistance = distance
                selectedColor = colorName
                
                // End early if the color is close enough
                if distance < 5 { break }
            }
        }
        
        return selectedColor.name
    }
}
