//
//  BmmCalendarViewController.swift
//  Bmemo
//
//  Created by Ama on 20/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit
import AMACalendar
import RxSwift
import RxCocoa

typealias calendarSelectCB = ((_ cal: (String, String)) -> ())

class BmmCalendarViewController: UIViewController {
    @IBOutlet weak var calendar: calendarView!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var sureBtn: UIButton!
    @IBOutlet weak var cancleBtn: UIButton!
    
    let disposeBag = DisposeBag()
    
    fileprivate var selectedGC: Variable<String> = Variable("")
    fileprivate var selectedLC: Variable<String> = Variable("")
    
    var calendarTupe: calendarSelectCB?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        RxMethod()
        
    }
    
    deinit {
        debugPrint("BmmCalendarViewController--deinit")
    }

}

// MARK: - open
extension BmmCalendarViewController {
    func didSelectCalendar( b: @escaping calendarSelectCB) {
        calendarTupe = b
    }
}

// MARK: - Rx
extension BmmCalendarViewController {
    fileprivate func RxMethod() {
        sureBtn
            .rx
            .tap
            .subscribe(onNext: { [weak self] (_) in
                self?.calendarTupe!((self!.selectedGC.value, self!.selectedLC.value))
                self?.dismiss(animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
        
        cancleBtn
            .rx
            .tap
            .subscribe(onNext: { [weak self] (_) in
                self?.dismiss(animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
        
        calendar
            .rx
            .controlEvent(.valueChanged)
            .map({ [weak self] _ in
                return self?.calendar
            })
            .shareReplay(1)
            .subscribe(onNext: { [weak self] (cal) in
                let formatter = DateFormatter()
                formatter.dateFormat = "YYYY-MM-dd"
                
                self?.selectedGC.value = formatter.string(from: cal!.selectedDate!.0)
                self?.selectedLC.value = cal!.selectedDate!.1
            })
            .addDisposableTo(disposeBag)
        
        Observable
            .of(selectedGC.asObservable(), selectedLC.asObservable())
            .merge()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] (_) in
                
                UIView.transition(with: (self?.calendarLabel)!,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    
                                    self?.calendarLabel.text = (self?.selectedGC.value)! + "  " + (self?.selectedLC.value)!
                }, completion: nil)
                
            })
            .addDisposableTo(disposeBag)
    }
}
