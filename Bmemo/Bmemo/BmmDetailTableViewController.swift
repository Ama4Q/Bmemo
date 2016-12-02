//
//  BmmDetailTableViewController.swift
//  Bmemo
//
//  Created by Ama on 11/29/16.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit

class BmmDetailTableViewController: UITableViewController {

    var tmpStatus: Bool = false
    
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.tmpStatus = true
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        })
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
        var cell:UITableViewCell?
        
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "BmmNinameCellId", for: indexPath) as! BmmNinameCell
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "BmmAddCellId", for: indexPath)
        case 2:
            fallthrough
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "BmmCalendarCellId", for: indexPath) as! BmmCalendarCell
        case 4:
            cell = tableView.dequeueReusableCell(withIdentifier: "BmmAlertCellId", for: indexPath)
        case 5:
            cell = tableView.dequeueReusableCell(withIdentifier: "BmmAlarmCellId", for: indexPath) as! BmmAlarmCell
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "BmmRemarkCellId", for: indexPath) as! BmmRemarkCell
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var hg: CGFloat = 44
        
        switch indexPath.row {
        case 0:
            hg = 80
        case 1:
            break
        case 2:
            fallthrough
        case 3:
            hg = 70
        case 4:
            break
        case 5:
            if tmpStatus {
                hg = 70
            } else {
                hg = 0
            }
        default:
            hg = 100
        }
        
        return hg
    }
    
}
