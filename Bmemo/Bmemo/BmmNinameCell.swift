//
//  BmmNinameCell.swift
//  Bmemo
//
//  Created by Ama on 02/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BmmNinameCell: BmmBaseCell {

    @IBOutlet weak var niNameTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewModel
            .asObservable()
            .map({
                ($0 as? BmmNinameViewModel)?.niName
            })
            .bindTo(niNameTextField.rx.text)
            .addDisposableTo(disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
