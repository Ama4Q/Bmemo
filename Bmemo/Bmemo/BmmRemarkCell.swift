//
//  BmmRemarkCell.swift
//  Bmemo
//
//  Created by Ama on 02/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit

class BmmRemarkCell: BmmBaseCell {

    @IBOutlet weak var remarkTextView: UITextView!
    
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
