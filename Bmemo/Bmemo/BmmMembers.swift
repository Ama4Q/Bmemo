//
//  BmmMembers.swift
//  Bmemo
//
//  Created by Ama on 06/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import Foundation
import ObjectMapper

class BmmMembers: Mappable {
    var photo: Data?
    var niName: String?
    var remark: String?
    var alarmDate: Date?
    var gregorianCalendar: String?
    var lunarCalendar: String?
    
    var lunar: String?
    var gregorian: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        photo <- map["photo"]
        niName <- map["niName"]
        remark <- map["remark"]
        alarmDate <- map["alarmDate"]
        lunarCalendar <- map["lunarCalendar"]
        gregorianCalendar <- map["gregorianCalendar"]
        
        lunar <- map["lunar"]
        gregorian <- map["gregorian"]
    }
}
