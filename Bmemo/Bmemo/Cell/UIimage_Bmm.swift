//
//  UIimage_Bmm.swift
//  Bmemo
//
//  Created by Ama on 11/25/16.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit

extension UIImage {
    class func resizedImage(iname: String) -> UIImage? {
        let image = UIImage(named: iname)
        
        guard let img = image else {
            return nil
        }
        
        return img.stretchableImage(withLeftCapWidth: Int(img.size.width * 0.5), topCapHeight: Int(img.size.height * 0.5))
    }
}
