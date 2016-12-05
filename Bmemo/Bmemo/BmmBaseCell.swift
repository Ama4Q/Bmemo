//
//  BmmBaseCell.swift
//  Bmemo
//
//  Created by Ama on 05/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit

class BmmBaseCell: UITableViewCell {
    
    private let cellIds: [String] = ["BmmNinameCellId",
                                     "BmmAddCellId",
                                     "BmmCalendarCellId",
                                     "BmmCalendarCellId",
                                     "BmmAlertCellId",
                                     "BmmAlarmCellId",
                                     "BmmRemarkCellId"]
    
    func cellWithIndexPath(tv: UITableView, ip: IndexPath) -> UITableViewCell {
        return tv.dequeueReusableCell(withIdentifier: cellIds[ip.row], for: ip)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

}
