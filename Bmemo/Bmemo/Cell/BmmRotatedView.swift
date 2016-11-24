//
//  BmmRotatedView.swift
//  Bmemo
//
//  Created by Ama on 11/24/16.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit

open class BmmRotatedView: UIView {
    var hiddenAfterAnimation = false
    var backView: BmmRotatedView?
    
    func addBackView(_ height: CGFloat, color: UIColor) {
        let view = BmmRotatedView(frame: CGRect.zero)
        view.backgroundColor = color
        view.layer.anchorPoint = CGPoint.init(x: 0.5, y: 1)
        view.layer.transform = view.transform3d()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        backView = view
        
        view.addConstraint(NSLayoutConstraint(item: view,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .height,
                                              multiplier: 1,
                                              constant: height))
        
        addConstraints([
            NSLayoutConstraint(item: view,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .top,
                               multiplier: 1,
                               constant: bounds.height - height + height / 2),
            NSLayoutConstraint(item: view,
                               attribute: .leading,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .leading,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: view,
                               attribute: .trailing,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .trailing,
                               multiplier: 1,
                               constant: 0)])
    }
}

extension BmmRotatedView: CAAnimationDelegate {
    func rotatedX(_ angle: CGFloat) {
        var allTransform = CATransform3DIdentity
        let rotateTransform = CATransform3DMakeRotation(angle, 1, 0, 0)
        allTransform = CATransform3DConcat(allTransform, rotateTransform)
        allTransform = CATransform3DConcat(allTransform, transform3d())
    }
    
    func transform3d() -> CATransform3D {
        var transform = CATransform3DIdentity
        transform.m34 = 2.5 / -2000
        return transform
    }
    
    func animation(_ timing: String, from: CGFloat, to: CGFloat, duration: TimeInterval, delay: TimeInterval, hidden: Bool) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.x")
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: timing)
        rotateAnimation.fromValue = from
        rotateAnimation.toValue = to
        rotateAnimation.duration = duration
        rotateAnimation.delegate = self
        rotateAnimation.fillMode = kCAFillModeForwards
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.beginTime = CACurrentMediaTime() + delay
        
        hiddenAfterAnimation = hidden
        layer.add(rotateAnimation, forKey: "rotation.x")
    }
    
    public func animationDidStart(_ anim: CAAnimation) {
        layer.shouldRasterize = true
        alpha = 1
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if hiddenAfterAnimation {
            alpha = 0
        }
        layer.removeAnimation(forKey: "rotation.x")
        layer.shouldRasterize = false
        rotatedX(CGFloat(0))
    }
}

extension UIView {
    func BmmTakeSnapshot(_ frame: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
        
        let context = UIGraphicsGetCurrentContext();
        context!.translateBy(x: frame.origin.x * -1, y: frame.origin.y * -1)
        
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        layer.render(in: currentContext)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
