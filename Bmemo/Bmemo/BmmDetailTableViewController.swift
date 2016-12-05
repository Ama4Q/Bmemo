//
//  BmmDetailTableViewController.swift
//  Bmemo
//
//  Created by Ama on 11/29/16.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit

public enum ExCell: String {
    case close = "close"
    case open = "open"
}

class BmmDetailTableViewController: UITableViewController {

    fileprivate lazy var alertStatus: ExCell = .close
    fileprivate lazy var addStatus: ExCell = .close
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()

        let headerView = BmmHeaderView()
        headerView.photo = UIImage(named: "photo")
        navigationItem.titleView = headerView
        headerView.reloadSizeWithScrollView(scrollView: tableView)
        
        headerView.handleClickActionWithClosure {
            
            print("aaa")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - Table view data source
extension BmmDetailTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BmmBaseCell().cellWithIndexPath(tv: tableView, ip: indexPath)
        if cell is BmmAlertCell {
            let alertCell = cell as? BmmAlertCell
            alertCell?.delegate = self
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(index: indexPath.row, cS: addStatus, aS: alertStatus)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectCell = tableView.cellForRow(at: indexPath)
        
        if selectCell is BmmAlarmCell {
            
        } else {
            // code test
            addStatus = .open
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}

// MARK: - BmmAlertCell cloure
extension BmmDetailTableViewController: BmmAlertCellDelegate {
    func isSwitch(on: Bool, alertCell: BmmAlertCell) {
        alertStatus = on == true ? .open : .close
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

