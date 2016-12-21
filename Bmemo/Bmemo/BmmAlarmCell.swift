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
                
                let formatter = DateFormatter()
                formatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
                return formatter.string(from: alarmDate)
            })
            .subscribe(onNext: { [weak self] (str) in
                
                UIView.transition(with: self!.alarmDateLabel,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self?.alarmDateLabel.text = str
                }, completion: nil)
                
            })
            .addDisposableTo(disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
