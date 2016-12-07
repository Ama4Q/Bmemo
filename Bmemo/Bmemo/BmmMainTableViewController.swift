//
//  BmmMainTableViewController.swift
//  Bmemo
//
//  Created by Ama on 11/23/16.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class BmmMainTableViewController: UITableViewController {
    
    fileprivate let BmmCloseCellHeight: CGFloat = 95
    fileprivate let BmmOpenCellHeight: CGFloat = 253
    
    fileprivate var cellHeights = [CGFloat]()
    
    let disposeBag = DisposeBag()
    fileprivate var dataSource: Variable<[BmmMembers]>? = parsingLocalData()

    override func viewDidLoad() {
        super.viewDidLoad()

        // setting UI
        UI()
        
        // add RxMethod
        RxObserve()
        
        // Rx datasource
        RxTableView()
    }
    
    
}

// MARK: - UI
extension BmmMainTableViewController {
    fileprivate func UI() {
        //self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        tableView
            .backgroundView = UIView
                .init(image: UIImage(named: "background")!, rect: tableView.frame)
        
        navigationController?
            .navigationBar
            .titleTextAttributes = [NSForegroundColorAttributeName :
                UIColor.color(hexStr: "FF88D5", alpha: 1)]
    }
}

// MARK: - private method
extension BmmMainTableViewController {
    fileprivate func createCellHeights() {
        guard let count = dataSource?.value.count else {
            return
        }
        for _ in 0..<count {
            cellHeights.append(BmmCloseCellHeight)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let detailVC = segue.destination as! BmmDetailTableViewController
        detailVC.member = dataSource?.value[(sender as? UIButton)!.tag]
    }
}

// MARK: - RxSwift Method
extension BmmMainTableViewController {
    fileprivate func RxTableView() {
        tableView.dataSource = nil
        dataSource?
            .asObservable()
            .bindTo(tableView.rx.items(cellIdentifier: "BmmCellId", cellType: memoCell.self)) { (idx, elemet, cell) in
                cell.dataFromCell(members: elemet, idx: idx)
            }.addDisposableTo(disposeBag)
    }
    
    fileprivate func RxObserve() {
        dataSource?
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.createCellHeights()
            })
            .addDisposableTo(disposeBag)
    }
}

// MARK: - tableView delegate
extension BmmMainTableViewController {
    
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
}
