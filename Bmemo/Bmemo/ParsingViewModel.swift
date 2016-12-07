//
//  ParsingViewModel.swift
//  Bmemo
//
//  Created by Ama on 07/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import Foundation
import RxSwift

func parsingLocalData() -> Variable<[BmmMembers]>? {
    let path = Bundle.main.path(forResource: "Tmpmembers", ofType: "plist")
    
    guard let pt = path else {
        return nil
    }
    
    let tmpArr = NSArray(contentsOfFile: pt) as? [[String: Any]]
    var mbs: [BmmMembers] = [BmmMembers]()
    
    for dict in tmpArr! {
        mbs.append(BmmMembers(JSON: dict)!)
    }
    
    return Variable(mbs)
}
