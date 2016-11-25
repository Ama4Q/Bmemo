//
//  UIColor_Bmm.swift
//  Bmemo
//
//  Created by Ama on 11/25/16.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit

extension UIColor {
    class func color(hexStr: String, alpha: CGFloat) -> UIColor {
        // 删除字符串空格
        var hStr = hexStr.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        guard hStr.characters.count >= 6 else {
            return UIColor.clear
        }
        
        if hStr.hasPrefix("0X") || hStr.hasPrefix("0x") {
            hStr = hStr.substring(from: hStr.index(hStr.endIndex, offsetBy: hStr.characters.count - 2))
        }
        
        if hStr.hasPrefix("#") {
            hStr = hStr.substring(from: hStr.index(after: hStr.startIndex))
        }
        
        guard hStr.characters.count == 6 else {
            return UIColor.clear
        }
        
        let rs = hStr.substring(with:
            Range(uncheckedBounds:
                (hStr.startIndex,
                 hStr.index(hStr.startIndex, offsetBy: 2))))
        
        let gs = hStr.substring(with:
            Range(uncheckedBounds:
                (hStr.index(hStr.startIndex, offsetBy: 2),
                 hStr.index(hStr.startIndex, offsetBy: 4))))
        
        let bs = hStr.substring(with:
            Range(uncheckedBounds:
                (hStr.index(hStr.startIndex, offsetBy: 4),
                 hStr.index(hStr.startIndex, offsetBy: 6))))
        
        var r: UInt32 = 0
        var g: UInt32 = 0
        var b: UInt32 = 0
        
        Scanner(string: rs).scanHexInt32(&r)
        Scanner(string: gs).scanHexInt32(&g)
        Scanner(string: bs).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: alpha)
        
    }
}
