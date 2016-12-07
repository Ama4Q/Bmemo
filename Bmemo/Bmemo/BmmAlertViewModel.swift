//
//  BmmAlertViewModel.swift
//  Bmemo
//
//  Created by Ama on 06/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import Foundation

class BmmAlertViewModel: BmmBaseViewModel {
    override var identifier: String? {
        return "BmmAlertCellId"
    }
    
    var on: Bool = false
    
    
    init(alarmDate: Date?) {
        super.init()
        
        guard alarmDate != nil else {
            on = false
            return
        }
        
        on = true
    }
}
