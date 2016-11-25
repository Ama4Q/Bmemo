//
//  UIView_Bmm.swift
//  Bmemo
//
//  Created by Ama on 11/25/16.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit

extension UIView {
    convenience init(image: UIImage, rect: CGRect) {
        self.init()
        
        let iv = UIImageView(image: image)
        let visual = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visual.frame = rect
        iv.addSubview(visual)
        
        self.addSubview(iv)
    }
}
