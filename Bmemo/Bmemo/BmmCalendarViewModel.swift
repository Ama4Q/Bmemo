//
//  BmmCalendarViewModel.swift
//  Bmemo
//
//  Created by Ama on 06/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import Foundation

class BmmCalendarViewModel: BmmBaseViewModel {

    var calendar: String?
    var title: String?
    
    override var identifier: String? {
        return "BmmCalendarCellId"
    }
    
    init(calendar: String?, title: String?) {
        super.init()
        self.calendar = calendar
        self.title = title
    }
}
