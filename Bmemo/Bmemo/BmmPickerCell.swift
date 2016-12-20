//
//  BmmPickerCell.swift
//  Bmemo
//
//  Created by Ama on 20/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BmmPickerCell: BmmBaseCell {

    @IBOutlet weak var datePicker: UIDatePicker!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        datePicker
            .rx
            .date
            .asObservable()
            .skip(1)
            .subscribe(onNext: { (d) in
                print(d)
            })
            .addDisposableTo(disposeBag)
        
        viewModel
            .asObservable()
            .map({ vm in
                guard let alarmDate = (vm as? BmmPickerViewModel)?.alarmDate else {
                    return Date()
                }
                return alarmDate
            })
            .bindTo(datePicker.rx.date)
            .addDisposableTo(disposeBag)
    }

}
