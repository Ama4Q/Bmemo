//
//  presentationController.swift
//  Bmemo
//
//  Created by Ama on 21/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit

class presentationAnimatorController: UIPresentationController {

    /// Presentation's coordinates
    var presentFrame = CGRect.zero
    var presentCenter = CGPoint.zero
    
    /// Whether the mask layer is available
    var coverViewInteractionEnable = false
    
    
    /// Cover view
    fileprivate(set) lazy var coverView = UIView()
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        // Custom the frame of presentedView
        presentedView?.frame = presentFrame
        presentedView?.center = presentCenter
        
        presentedView?.backgroundColor = UIColor.clear
        
        // UI
        UI()
    }
}

extension presentationAnimatorController {
    fileprivate func UI() {
        containerView?.insertSubview(coverView, at: 0)
        coverView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        coverView.frame = containerView?.bounds ?? CGRect.zero
        
        if coverViewInteractionEnable {
            coverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(coverViewDidTap)))
        }
    }
    
    @objc fileprivate func coverViewDidTap() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
