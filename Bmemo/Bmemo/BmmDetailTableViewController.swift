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

    fileprivate lazy var addStatus: cellStatus = .close
    fileprivate lazy var alertStatus: cellStatus = .close
    fileprivate lazy var pickerStatus: cellStatus = .close
    fileprivate var models: [BmmBaseViewModel]?
    
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
        
        Observable
            .just(member)
            .asObservable()
            .subscribe(onNext: { [weak self] (ms) in
                self?.models =
                    [BmmNinameViewModel(niName: ms?.niName),
                     BmmAddViewModel(),
                     BmmCalendarViewModel(gC: ms?.gregorianCalendar, lC: ms?.lunarCalendar),
                     BmmAlertViewModel(alarmDate: ms?.alarmDate),
                     BmmAlarmViewModel(alarmDate: ms?.alarmDate),
                     BmmRemarkViewModel(remark: ms?.remark)]
                
                if ms?.gregorianCalendar != nil {
                    self?.addStatus = .open
                }
                
                if ms?.alarmDate != nil {
                    self?.alertStatus = .open
                }
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
        let cvm = models![indexPath.row]
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
        
        return CGFloat(index: indexPath.row, aS: addStatus, alS: alertStatus, pkS: pickerStatus)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        switch cell.self {
        case is BmmAddCell:
            if addStatus == .close {
                // code test
                addStatus = .open
                tableViewUpdates()
            }
        case is BmmCalendarCell:
            break
        case is BmmAlarmCell:
            if pickerStatus == .close {
                pickerStatus = .open
                models?.insert(BmmPickerViewModel(alarmDate: (models?[4] as! BmmAlarmViewModel).alarmDate), at: 5)
                tableView.insertItemsAtIndexPaths([IndexPath(row: 5, section: 0)], animationStyle: .middle)
            } else {
                pickerStatus = .close
                models?.remove(at: 5)
                tableView.deleteRows(at: [IndexPath(row: 5, section: 0)], with: .middle)
            }
        default:
            break
        }
    }
}

// MARK: - BmmAlertCell cloure
extension BmmDetailTableViewController: BmmAlertCellDelegate {
    func isSwitch(on: Bool, alertCell: BmmAlertCell) {
        alertStatus = (on == true) ? .open : .close
        pickerStatus = .close
        tableViewUpdates()
    }
}


// MARK: - BmmPickerCellDelegate
extension BmmDetailTableViewController: BmmPickerCellDelegate {
    func pickerDateDidChanged(date: Date, cell: BmmPickerCell) {
        
        models?.replaceSubrange(Range(4...5),
                             with: [BmmAlarmViewModel(alarmDate: date),
                                    BmmPickerViewModel(alarmDate: date)])
        tableView.reloadData()
    }
}

