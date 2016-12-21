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

protocol BmmPickerCellDelegate: class {
    func pickerDateDidChanged(date: Date, cell: BmmPickerCell)
}
class BmmPickerCell: BmmBaseCell {

    @IBOutlet weak var datePicker: UIDatePicker!
    weak var delegate: BmmPickerCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        datePicker
            .rx
            .date
            .skip(1)
            .subscribe(onNext: { [weak self] (date) in
                self?.delegate?.pickerDateDidChanged(date: date, cell: self!)
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
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }

}
