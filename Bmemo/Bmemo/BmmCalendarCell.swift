//
//  BmmCalendarCell.swift
//  Bmemo
//
//  Created by Ama on 02/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit

class BmmCalendarCell: BmmBaseCell {

    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewModel
            .asObservable()
            .map({
                (($0 as? BmmCalendarViewModel)?.calendar,
                 ($0 as? BmmCalendarViewModel)?.title)
            })
            .subscribe(onNext: { [weak self] (cvm) in
                self?.dateTextField.text = cvm.0
                self?.calendarLabel.text = cvm.1
            })
            .addDisposableTo(disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
