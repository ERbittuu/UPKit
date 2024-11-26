//
//  ZigzagBorderView.swift
//  junglebook
//
//  Created by Utsav Patel on 13/08/2024.
//

import UIKit

public class ZigzagBorderView: UIView {
    var zigzagHeight: CGFloat = 12.0
    var zigzagWidth: CGFloat = 12.0
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        applyZigzagMask()
    }
    
    private func applyZigzagMask() {
        // Remove any existing mask
        layer.mask = nil
        
        // Create a mask layer
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        
        // Create the zigzag path
        let path = UIBezierPath()
        let rectWidth = bounds.width
        let rectHeight = bounds.height
        
        // Draw zigzag pattern around all four sides
        let numberOfZigzagsTop = Int(rectWidth / (zigzagWidth * 2))
        let halfZigzagWidth = zigzagWidth / 2
        let halfZigzagHeight = zigzagHeight / 2
        
        // Top border
        path.move(to: CGPoint(x: 0, y: 0))
        for i in 0..<numberOfZigzagsTop {
            let x = CGFloat(i) * zigzagWidth * 2
            path.addLine(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x + halfZigzagWidth, y: halfZigzagHeight))
            path.addLine(to: CGPoint(x: x + zigzagWidth * 2, y: 0))
        }
        path.addLine(to: CGPoint(x: rectWidth, y: 0))
        
        // Right border
        let numberOfZigzagsRight = Int(rectHeight / (zigzagWidth * 2))
        for i in 0..<numberOfZigzagsRight {
            let y = CGFloat(i) * zigzagWidth * 2
            path.addLine(to: CGPoint(x: rectWidth, y: y))
            path.addLine(to: CGPoint(x: rectWidth - halfZigzagWidth, y: y + halfZigzagHeight))
            path.addLine(to: CGPoint(x: rectWidth, y: y + zigzagWidth * 2))
        }
        path.addLine(to: CGPoint(x: rectWidth, y: rectHeight))
        
        // Bottom border
        let numberOfZigzagsBottom = Int(rectWidth / (zigzagWidth * 2))
        for i in 0..<numberOfZigzagsBottom {
            let x = CGFloat(i) * zigzagWidth * 2
            path.addLine(to: CGPoint(x: rectWidth - x, y: rectHeight))
            path.addLine(to: CGPoint(x: rectWidth - x - halfZigzagWidth, y: rectHeight - halfZigzagHeight))
            path.addLine(to: CGPoint(x: rectWidth - x - zigzagWidth * 2, y: rectHeight))
        }
        path.addLine(to: CGPoint(x: 0, y: rectHeight))
        
        // Left border
        let numberOfZigzagsLeft = Int(rectHeight / (zigzagWidth * 2))
        for i in 0..<numberOfZigzagsLeft {
            let y = CGFloat(i) * zigzagWidth * 2
            path.addLine(to: CGPoint(x: 0, y: rectHeight - y))
            path.addLine(to: CGPoint(x: halfZigzagWidth, y: rectHeight - y - halfZigzagHeight))
            path.addLine(to: CGPoint(x: 0, y: rectHeight - y - zigzagWidth * 2))
        }
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        path.lineWidth = 1
        path.close()
        
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}
