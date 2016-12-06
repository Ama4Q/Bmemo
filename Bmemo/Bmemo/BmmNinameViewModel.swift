//
//  BmmNinameViewModel.swift
//  Bmemo
//
//  Created by Ama on 06/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import Foundation

class BmmNinameViewModel: BmmBaseViewModel {

    var niName: String?
    override var identifier: String? {
        return "BmmNinameCellId"
    }
    
    init(niName: String?) {
        super.init()
        self.niName = niName
    }
}
