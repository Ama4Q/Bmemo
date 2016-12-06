//
//  BmmAlarmViewModel.swift
//  Bmemo
//
//  Created by Ama on 06/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import Foundation

class BmmAlarmViewModel: BmmBaseViewModel {
    var alarmDate: Date?
    override var identifier: String? {
        return "BmmAlarmCellId"
    }
    
    init(alarmDate: Date?) {
        super.init()
        self.alarmDate = alarmDate
    }
}
