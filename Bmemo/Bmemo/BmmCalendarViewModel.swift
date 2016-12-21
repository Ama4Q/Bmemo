//
//  BmmCalendarViewModel.swift
//  Bmemo
//
//  Created by Ama on 06/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import Foundation

class BmmCalendarViewModel: BmmBaseViewModel {

    var gCalendar: String?
    var lCalendar: String?
    
    override var identifier: String? {
        return "BmmCalendarCellId"
    }
    
    init(gC: String?, lC: String?) {
        super.init()
        gCalendar = gC
        lCalendar = lC
    }
}
