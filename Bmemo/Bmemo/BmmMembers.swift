//
//  BmmMembers.swift
//  Bmemo
//
//  Created by Ama on 06/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import Foundation
import ObjectMapper


struct BmmMembers: Mappable {
    var photo: Data?
    var niName: String?
    var alarmDatre: Date?
    var gregorianCalendar: String?
    var lunarCalendar: String?
    
    var gregorian: String?
    var lunar: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        photo <- map["photo"]
        niName <- map["niName"]
        alarmDatre <- map["alarmDatre"]
        gregorianCalendar <- map["gregorianCalendar"]
        lunarCalendar <- map["lunarCalendar"]
        
        gregorian <- map["gregorian"]
        lunar <- map["lunar"]
    }
}
