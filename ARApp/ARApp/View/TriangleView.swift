//
//  TriangleView.swift
//  ARApp
//
//  Created by Khan Sharmin on 18/03/20.
//  Copyright © 2020 Khan Sharmin. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class TriangleView : UIView {
    var color: UIColor! = UIColor.green
    var margin: CGFloat! = 0
    
    @IBInspectable var marginInsp: Double {
        get { return Double(margin)}
        set { margin = CGFloat(newValue)}
    }
    
    
    @IBInspectable var fillColor: UIColor? {
        get { return color }
        set{ color = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX + margin, y: rect.maxY - margin))
        context.addLine(to: CGPoint(x: rect.maxX - margin, y: rect.maxY - margin))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY + margin))
        context.closePath()
        
        context.setFillColor(color.cgColor)
        context.fillPath()
    }
}

extension UIView {
    
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians)
        self.transform = rotation
    }
}
