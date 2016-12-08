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

    fileprivate lazy var alertStatus: Variable<cellStatus> = Variable(.close)
    fileprivate lazy var addStatus: Variable<cellStatus> = Variable(.close)
    fileprivate var models: [BmmBaseViewModel]?
    
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
}

// MARK: - RxSwift method
extension BmmDetailTableViewController {
    fileprivate func RxMethod() {
        
        //MARK: - dataSource Observer
        Observable
            .just(member)
            .asObservable()
            .subscribe(onNext: { [weak self] ms in
                self?.models =
                    [BmmNinameViewModel(niName: ms?.niName),
                     BmmBaseViewModel(),
                     BmmCalendarViewModel(gCalendar: ms?.gregorianCalendar, lCalendar: ms?.lunarCalendar),
                     BmmAlertViewModel(alarmDate: ms?.alarmDate),
                     BmmAlarmViewModel(alarmDate: ms?.alarmDate),
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
    }
}

// MARK: - Table view data source
extension BmmDetailTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cvm = models?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cvm!.identifier!, for: indexPath)
        (cell as? BmmBaseCell)?.viewModel.value = cvm!
        
        if cell is BmmAlertCell {
            (cell as? BmmAlertCell)?.delegate = self
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(index: indexPath.row, aS: addStatus.value, alS: alertStatus.value)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 1:
            if addStatus.value != .open {
                // code test
                addStatus.value = .open
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            
        case 2:
            break
            
        case 4:
            break
        
        default:
            break
        }
    }
}

// MARK: - BmmAlertCell cloure
extension BmmDetailTableViewController: BmmAlertCellDelegate {
    func isSwitch(on: Bool, alertCell: BmmAlertCell) {
        alertStatus.value = (on == true) ? .open : .close
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

