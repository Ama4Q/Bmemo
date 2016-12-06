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
            .map({
                ($0 as? BmmAlarmViewModel)?.alarmDate
            })
            .subscribe(onNext: { [weak self] (alarmDate) in
                self?.alarmNameLabel.text = nil
                self?.alarmDateLabel.text = String(describing: alarmDate)
            })
            .addDisposableTo(disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
