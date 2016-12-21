//
//  presentationAnimator.swift
//  Bmemo
//
//  Created by Ama on 21/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit

enum presentedStatus {
    case presented
    case dismissed
}
class presentationAnimator: NSObject {

    typealias presentedClouse = ((_ status: presentedStatus) -> ())
    
    /// Presentation's coordinates
    var presentFrame = CGRect.zero
    var presentCenter = CGPoint.zero
    
    
    /// CallBack
    var presentedCallBack: presentedClouse?
    
    
    /// Presented/dismissed
    fileprivate lazy var isPresented = false
    fileprivate var presentation: presentationAnimatorController?
    
    init(callBask: @escaping presentedClouse) {
        super.init()
        presentedCallBack = callBask
    }
    
}

// MARK: - UIViewControllerAnimatedTransitioning
extension presentationAnimator: UIViewControllerAnimatedTransitioning {
    
    fileprivate func presentedAnimation(forTransitionContext context: UIViewControllerContextTransitioning) {
        
        let toView = context.view(forKey: .to)!
        context.containerView.addSubview(toView)
        
        toView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        // default 0.5, 0.5
        // toView.layer.position = CGPoint(x: 0.5, y: 0.5)
        
        UIView.animate(withDuration: transitionDuration(using: context),
                              delay: 0,
             usingSpringWithDamping: 0.6,
              initialSpringVelocity: 0,
                            options: .curveEaseOut,
                         animations: {
                            
                            toView.transform = CGAffineTransform.identity
        }, completion: { _ in
            
            context.completeTransition(true)
            
        })
    }
    
    fileprivate func dismissedAnimation(forTransitionContext context: UIViewControllerContextTransitioning) {
        let fromView = context.view(forKey: .from)
        
        UIView.animate(withDuration: 0.3,
                         animations: {
                            fromView?.alpha = 0
                            self.presentation?.coverView.alpha = 0
        }, completion: { _ in
            
            fromView?.removeFromSuperview()
            context.completeTransition(true)
            
        })
        
    }
    
    /// Animated duration
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ?
            presentedAnimation(forTransitionContext: transitionContext) :
            dismissedAnimation(forTransitionContext: transitionContext)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension presentationAnimator: UIViewControllerTransitioningDelegate {
    
    /// Change the size of presentation's view
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        presentation = presentationAnimatorController(presentedViewController: presented, presenting: presenting)
        presentation?.presentFrame = presentFrame
        presentation?.presentCenter = presentCenter
        
        return presentation
    }
    
    /// Presented animation
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        presentedCallBack!(.presented)
        
        // must to implement UIViewControllerAnimatedTransitioning before return self
        return self
    }
    
    /// Dismissed animation
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        presentedCallBack!(.dismissed)
        
        // must to implement UIViewControllerAnimatedTransitioning before return self
        return self
    }
}
