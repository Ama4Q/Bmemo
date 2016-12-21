//
//  BmmRemarkCell.swift
//  Bmemo
//
//  Created by Ama on 02/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BmmRemarkCell: BmmBaseCell {

    @IBOutlet weak var remarkTextView: UITextView!
    
    @IBInspectable var cColor: UIColor?
    @IBInspectable var wColor: UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
            
        viewModel
            .asObservable()
            .map({
                ($0 as? BmmRemarkViewModel)?.remark
            })
            .bindTo(remarkTextView.rx.text)
            .addDisposableTo(disposeBag)
        
        remarkTextView
            .rx
            .text
            .map({
                $0?.characters.count
            })
            .shareReplay(1)
            .subscribe(onNext: { [weak self] c in
                self?.remarkTextView.backgroundColor =
                    (c! <= 0) ? self?.cColor : self?.wColor
            })
            .addDisposableTo(disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
