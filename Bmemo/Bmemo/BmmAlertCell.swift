//
//  BmmAlertCell.swift
//  Bmemo
//
//  Created by Ama on 05/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit

protocol BmmAlertCellDelegate {
    func isSwitch(on: Bool, alertCell: BmmAlertCell)
}

class BmmAlertCell: BmmBaseCell {

    var delegate: BmmAlertCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func BmmSwitch(_ sender: UISwitch) {
        delegate?.isSwitch(on: sender.isOn, alertCell: self)
    }

}
