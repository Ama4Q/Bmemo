//
//  CGFloat_ExCell.swift
//  Bmemo
//
//  Created by Ama on 05/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit

// MARK: - cell height extension
extension CGFloat {
    init(index: Int, aS: ExCell, alS: ExCell) {
        self = 44
        switch index {
        case 0:
            self = 80
        case 1:
            break
        case 2:
            fallthrough
        case 3:
            if aS.rawValue == "open" {
                self = 70
            } else {
                self = 0
            }
        case 4:
            break
        case 5:
            if alS.rawValue == "open" {
                self = 70
            } else {
                self = 0
            }
        default:
            self = 100
        }
    }
}
