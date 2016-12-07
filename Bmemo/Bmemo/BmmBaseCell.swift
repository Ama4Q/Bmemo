//
//  BmmBaseCell.swift
//  Bmemo
//
//  Created by Ama on 05/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BmmBaseCell: UITableViewCell {
    
    var viewModel: Variable<BmmBaseViewModel> = Variable(BmmBaseViewModel())
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

}
