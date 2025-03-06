//
//  UIProgressView+ext.swift
//  CardCamClash
//
//  Created by Card Cam Clash on 2025/3/6.
//


import UIKit

@IBDesignable
extension UIProgressView {
    
    @IBInspectable var barHeight: CGFloat {
        get {
            return transform.d * bounds.height
        }
        set {
            let scaleY = newValue / bounds.height
            transform = CGAffineTransform(scaleX: 1.0, y: scaleY)
        }
    }
}
