//
//  BmmCalendarCell.swift
//  Bmemo
//
//  Created by Ama on 02/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit

class BmmCalendarCell: BmmBaseCell {

    @IBOutlet weak var gCalendarLabel: UILabel!
    @IBOutlet weak var lCalendarLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewModel
            .asObservable()
            .map({
                (($0 as? BmmCalendarViewModel)?.gCalendar, ($0 as? BmmCalendarViewModel)?.lCalendar)
            })
            .subscribe(onNext: { [weak self] (cvm) in
                self?.gCalendarLabel.text = cvm.0
                self?.lCalendarLabel.text = cvm.1
            })
            .addDisposableTo(disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
