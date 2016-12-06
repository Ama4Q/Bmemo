//
//  BmmRemarkViewModel.swift
//  Bmemo
//
//  Created by Ama on 06/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import Foundation

class BmmRemarkViewModel: BmmBaseViewModel {
    var remark: String?
    override var identifier: String? {
        return "BmmRemarkCellId"
    }
    
    init(remark: String?) {
        super.init()
        self.remark = remark
    }
}
