//
//  BmmDetailTableViewController.swift
//  Bmemo
//
//  Created by Ama on 11/29/16.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

public enum cellStatus: String {
    case close = "close"
    case open = "open"
}

class BmmDetailTableViewController: UITableViewController {

    fileprivate lazy var addStatus: Variable<cellStatus> = Variable(.close)
    fileprivate lazy var alertStatus: Variable<cellStatus> = Variable(.close)
    fileprivate lazy var pickerStatus: Variable<cellStatus> = Variable(.close)
    fileprivate lazy var models: Variable<[BmmBaseViewModel]> = Variable([])
    
    fileprivate static let presention = presentationAnimator { (_) in
        print("didtap...")
    }
    
    let disposeBag = DisposeBag()
    var member: BmmMembers?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI
        UI()
        
        // Rx_observe
        RxMethod()
        
    }
    
    deinit {
        debugPrint("BmmDetailTableViewController--deinit")
    }

}

// MARK: - UI
extension BmmDetailTableViewController {
    fileprivate func UI() {
        tableView.tableFooterView = UIView()
        
        let headerView = BmmHeaderView()
        headerView.photo = UIImage(named: "photo")
        navigationItem.titleView = headerView
        headerView.reloadSizeWithScrollView(scrollView: tableView)
        
        headerView.handleClickActionWithClosure {
            debugPrint("aaa")
        }
    }
    
    fileprivate func tableViewUpdates() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let toViewController = segue.destination
        
        if toViewController is BmmCalendarViewController {
            toViewController.modalPresentationStyle = .custom
            toViewController.transitioningDelegate = BmmDetailTableViewController.presention
            
            BmmDetailTableViewController.presention.presentFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: 360)
            BmmDetailTableViewController.presention.presentCenter = view.center
        }
    }
}

// MARK: - RxSwift method
extension BmmDetailTableViewController {
    fileprivate func RxMethod() {
        
        //MARK: - dataSource Observer
        Observable
            .just(member)
            .asObservable()
            .subscribe(onNext: { [weak self] ms in
                
                self?.models.value =
                    [BmmNinameViewModel(niName: ms?.niName),
                     BmmBaseViewModel(),
                     BmmCalendarViewModel(gC: ms?.gregorianCalendar, lC: ms?.lunarCalendar),
                     BmmAlertViewModel(alarmDate: ms?.alarmDate),
                     BmmAlarmViewModel(alarmDate: ms?.alarmDate),
                     BmmPickerViewModel(alarmDate: ms?.alarmDate),
                     BmmRemarkViewModel(remark: ms?.remark)]
                
                if ms?.gregorianCalendar != nil {
                    self?.addStatus.value = .open
                }
                
                if ms?.alarmDate != nil {
                    self?.alertStatus.value = .open
                }
            })
            .addDisposableTo(disposeBag)
        
        //MARK: - back Item Observer
        Observable
            .just(presentingViewController)
            .asObservable()
            .filter({
                $0 != nil
            })
            .subscribe(onNext: { [weak self] _ in
                let backItem = UIBarButtonItem(title: NSLocalizedString("取消", comment: ""), style: .done, target: nil, action: nil)
                self?.navigationItem.leftBarButtonItem = backItem
                backItem
                    .rx
                    .tap
                    .subscribe(onNext: { _ in
                        self?.dismiss(animated: true, completion: nil)
                    })
                    .addDisposableTo((self!.disposeBag))
            })
            .addDisposableTo(disposeBag)
        
        models
            .asObservable()
            .skip(1)
            .subscribe(onNext: { [weak self] (_) in
                self?.tableView.reloadData()
            })
            .addDisposableTo(disposeBag)
    }
}

// MARK: - Table view data source
extension BmmDetailTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.value.count 
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cvm = models.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cvm.identifier!, for: indexPath)
        (cell as? BmmBaseCell)?.viewModel.value = cvm
        
        if cell is BmmAlertCell {
            (cell as? BmmAlertCell)?.delegate = self
        }
        
        if cell is BmmPickerCell {
            (cell as? BmmPickerCell)?.delegate = self
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(index: indexPath.row, aS: addStatus.value, alS: alertStatus.value, pkS: pickerStatus.value)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 1:
            if addStatus.value != .open {
                // code test
                addStatus.value = .open
                tableViewUpdates()
            }
            
        case 4:
            pickerStatus.value = (pickerStatus.value == .close) ? .open : .close
            tableViewUpdates()
        
        default:
            break
        }
    }
}

// MARK: - BmmAlertCell cloure
extension BmmDetailTableViewController: BmmAlertCellDelegate {
    func isSwitch(on: Bool, alertCell: BmmAlertCell) {
        alertStatus.value = (on == true) ? .open : .close
        pickerStatus.value = .close
        tableViewUpdates()
    }
}


// MARK: - BmmPickerCellDelegate
extension BmmDetailTableViewController: BmmPickerCellDelegate {
    func pickerDateDidChanged(date: Date, cell: BmmPickerCell) {
        
        models
            .value
            .replaceSubrange(Range(4...5),
                             with: [BmmAlarmViewModel(alarmDate: date),
                                    BmmPickerViewModel(alarmDate: date)])
    }
}

