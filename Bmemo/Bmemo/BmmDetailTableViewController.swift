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
    
    fileprivate static var presention = presentationAnimator { (_) in}
    
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
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let headerView = BmmHeaderView()
        headerView.photo = UIImage(named: "photo")?.drawHeaderImage()
        navigationItem.titleView = headerView
        headerView.reloadSizeWithScrollView(scrollView: tableView)
        
        headerView.handleClickActionWithClosure { [unowned self] in
            debugPrint("aaa")
            BmmSysPicture().syspicture(ctrol: self, cb: { (image) in
                debugPrint(image)
            })
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
            
            (toViewController as! BmmCalendarViewController)
                .didSelectCalendar(b: { [unowned self] calendar in
                    if self.addStatus == .close {
                        self.addStatus = .open
                        self.models?.insert(BmmCalendarViewModel(gC: calendar.0, lC: calendar.1), at: 2)
                        self.tableView.insertItemsAtIndexPaths([IndexPath(row: 2, section: 0)], animationStyle: .top)
                    }
            })
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
                     BmmAlertViewModel(alarmDate: ms?.alarmDate),
                     BmmRemarkViewModel(remark: ms?.remark)]
                
                if ms?.gregorianCalendar != nil {
                    self?.addStatus = .open
                    self?.models?.insert(BmmCalendarViewModel(gC: ms?.gregorianCalendar, lC: ms?.lunarCalendar), at: 2)
                }
                
                if ms?.alarmDate != nil {
                    self?.alertStatus = .open
                    self?.models?.insert(BmmAlarmViewModel(alarmDate: ms?.alarmDate), at: self!.models!.count - 1)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        switch cell.self {
        case is BmmAlarmCell:
            let row = models!.count
            
            switch pickerStatus {
            case .close:
                pickerStatus = .open
                models?.insert(BmmPickerViewModel(alarmDate: member?.alarmDate ?? Date()), at: row - 1)
                tableView.insertItemsAtIndexPaths([IndexPath(row: row - 1, section: 0)], animationStyle: .fade)
            default:
                pickerStatus = .close
                models?.remove(at: row - 2)
                tableView.deleteRows(at: [IndexPath(row: row - 2, section: 0)], with: .fade)
            }
        default:
            break
        }
    }
}

// MARK: - BmmAlertCell cloure
extension BmmDetailTableViewController: BmmAlertCellDelegate {
    func isSwitch(on: Bool, alertCell: BmmAlertCell) {
        var row = models!.count
        
        switch alertStatus {
        case .close:
            alertStatus = .open
            
            models?.insert(BmmAlarmViewModel(alarmDate: member?.alarmDate ?? Date()), at: row - 1)
            tableView.insertItemsAtIndexPaths([IndexPath(row: row - 1, section: 0)], animationStyle: .top)
        default:
            alertStatus = .close
            var idxs:[IndexPath] = Array()
            
            if pickerStatus == .open {
                pickerStatus = .close
                models?.remove(at: row - 2)
                idxs.append(IndexPath(row: row - 2, section: 0))
                row -= 1
            }
            
            models?.remove(at: row - 2)
            idxs.insert(IndexPath(row: row - 2, section: 0), at: 0)
            
            tableView.deleteRows(at: idxs, with: .fade)
        }
    }
}


// MARK: - BmmPickerCellDelegate
extension BmmDetailTableViewController: BmmPickerCellDelegate {
    func pickerDateDidChanged(date: Date, cell: BmmPickerCell) {
        
        let idx = models?.count
        
        models?.replaceSubrange(Range(idx! - 4...idx! - 2),
                             with: [BmmAlertViewModel(alarmDate: date),
                                    BmmAlarmViewModel(alarmDate: date),
                                    BmmPickerViewModel(alarmDate: date)])
        
        UIView.transition(with: tableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.tableView.reloadData()
        }, completion: nil)
    }
}

