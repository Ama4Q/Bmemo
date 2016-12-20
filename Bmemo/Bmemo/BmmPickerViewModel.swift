//
//  BmmPickerView.swift
//  Bmemo
//
//  Created by Ama on 20/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit

class BmmPickerViewModel: BmmBaseViewModel {

    var alarmDate: Date?
    override var identifier: String? {
        return "BmmPickerCellId"
    }
    
    init(alarmDate: Date?) {
        super.init()
        self.alarmDate = alarmDate
    }
}
