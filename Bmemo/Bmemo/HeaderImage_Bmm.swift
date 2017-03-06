//
//  BmmHeader+UIImage.swift
//  Bmemo
//
//  Created by Ama on 06/03/2017.
//  Copyright © 2017 Ama. All rights reserved.
//

import UIKit

extension UIImage {
    func drawHeaderImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: 8)
        
        path.addClip()
        
        draw(at: CGPoint.zero)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
}
