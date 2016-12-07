//
//  BmmAlarmCell.swift
//  Bmemo
//
//  Created by Ama on 02/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit

class BmmAlarmCell: BmmBaseCell {

    @IBOutlet weak var alarmNameLabel: UILabel!
    @IBOutlet weak var alarmDateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewModel
            .asObservable()
            .map({ vm in
                guard let alarmDate = (vm as? BmmAlarmViewModel)?.alarmDate else {
                    return String()
                }
                return String(describing: alarmDate)
            })
            .bindTo(alarmDateLabel.rx.text)
            .addDisposableTo(disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
