//
//  BmmMainTableViewController.swift
//  Bmemo
//
//  Created by Ama on 11/23/16.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit

class BmmMainTableViewController: UITableViewController {
    
    let BmmCloseCellHeight: CGFloat = 95
    let BmmOpenCellHeight: CGFloat = 253
    
    var cellHeights = [CGFloat]()
    let rows = 10
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        createCellHeights()
        //self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        tableView.backgroundView = UIView.init(image: UIImage(named: "background")!, rect: tableView.frame)
    }
    
    func createCellHeights() {
        for _ in 0...rows {
            cellHeights.append(BmmCloseCellHeight)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as memoCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == BmmCloseCellHeight {
            cell.selectedAnimation(false, animated: false, completion: nil)
        } else {
            cell.selectedAnimation(true, animated: false, completion: nil)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BmmCellId", for: indexPath) as! memoCell
        
        cell.photo = UIImage(named: "photo")

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! memoCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        if cellHeights[indexPath.row] == BmmCloseCellHeight { // open cell
            cellHeights[indexPath.row] = BmmOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights[indexPath.row] = BmmCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            }, completion: nil)
        
    }
}
