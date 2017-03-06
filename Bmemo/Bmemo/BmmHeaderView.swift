//
//  BmmHeaderView.swift
//  Bmemo
//
//  Created by Ama on 11/29/16.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

typealias ClickHeaderClosure = () -> ()

open class BmmHeaderView: UIView {
    
    let disposeBag = DisposeBag()

    fileprivate let kContentOffset = "contentOffset"
    fileprivate var clickHeaderClosure: ClickHeaderClosure?
    
    
    open var photo: UIImage? {
        willSet {
            headerBtn?.setBackgroundImage(newValue, for: .normal)
            headerBtn?.setBackgroundImage(newValue, for: .highlighted)
        }
    }
    open var boardColor: UIColor? {
        willSet {
            headerBtn?.layer.borderColor = newValue?.cgColor
        }
    }
    
    // MARK: - Rxsiwft scrollView
    fileprivate var headerBtn: UIButton? {
        willSet {
            newValue?.rx
                .controlEvent(.touchUpInside)
                .subscribe({ [weak self] _ in
                    self?.clickHeaderClosure!()
                    })
                .addDisposableTo(disposeBag)
        }
    }
    
    fileprivate var scrollView: UIScrollView? {
        willSet {
            newValue?.rx
                .observe(CGPoint.self, kContentOffset)
                .subscribe(onNext: { [weak self] (point) in
                    guard let offsety = point?.y else { return }
                    var scale: CGFloat = 1.0
                    if offsety < 0 { scale = min(1.2, 1 - offsety / 300) } else
                        if offsety > 0 { scale = max(0.55, 1 - offsety / 300) }
                    
                    self?.headerBtn?
                        .transform = CGAffineTransform(scaleX: scale, y: scale)
                    self?.headerBtn?
                        .frame
                        .origin
                        .y = 15
                    })
                .addDisposableTo(disposeBag)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        UIInitial()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("BmmHeaderView - deinit")
    }

}


// MARK: - UI
extension BmmHeaderView {
    fileprivate func UIInitial() {
        let kWidth = 63
        
        frame = CGRect(x: 0, y: 0, width: kWidth, height: kWidth)
        
        headerBtn = UIButton(frame: frame)
        addSubview(headerBtn!)
    }
}

// MARK: - open
extension BmmHeaderView {
    func reloadSizeWithScrollView(scrollView: UIScrollView) {
        self.scrollView = scrollView
    }
    
    func handleClickActionWithClosure(closure: @escaping ClickHeaderClosure) {
        clickHeaderClosure = closure
        isUserInteractionEnabled = true
    }
}
