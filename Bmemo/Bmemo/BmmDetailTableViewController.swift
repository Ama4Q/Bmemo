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

public enum ExCell: String {
    case close = "close"
    case open = "open"
}

class BmmDetailTableViewController: UITableViewController {

    fileprivate lazy var alertStatus: Variable<ExCell> = Variable(.close)
    fileprivate lazy var addStatus: Variable<ExCell> = Variable(.close)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            print("aaa")
        }
    }
}

// MARK: - RxSwift method
extension BmmDetailTableViewController {
    fileprivate func RxMethod() {
        // MARK: - cell status
        Observable
            .of(addStatus.asObservable(), alertStatus.asObservable())
            .merge()
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
            })
            .addDisposableTo(disposeBag)
        
        Observable
            .just(member)
            .asObservable()
            .subscribe(onNext: { [weak self] ms in
                self?.models =
                    [BmmNinameViewModel(niName: ms?.niName),
                     BmmBaseViewModel(),
                     BmmCalendarViewModel(calendar: ms?.gregorianCalendar, title: ms?.gregorian),
                     BmmCalendarViewModel(calendar: ms?.lunarCalendar, title: ms?.lunar),
                     BmmAlertViewModel(),
                     BmmAlarmViewModel(alarmDate: ms?.alarmDate),
                     BmmRemarkViewModel(remark: ms?.remark)]
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
            let alertCell = cell as? BmmAlertCell
            alertCell?.delegate = self
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(index: indexPath.row, aS: addStatus.value, alS: alertStatus.value)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectCell = tableView.cellForRow(at: indexPath)
        
        if selectCell is BmmAlarmCell {
            
        } else {
            // code test
            addStatus.value = .open
        }
    }
}

// MARK: - BmmAlertCell cloure
extension BmmDetailTableViewController: BmmAlertCellDelegate {
    func isSwitch(on: Bool, alertCell: BmmAlertCell) {
        alertStatus.value = (on == true) ? .open : .close
    }
}

