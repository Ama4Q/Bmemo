//
//  BmmTableViewCell.swift
//  Bmemo
//
//  Created by Ama on 11/24/16.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit

open class BmmTableViewCell: UITableViewCell {

    @IBOutlet weak open var detailView: UIView!
    @IBOutlet weak open var detailViewTop: NSLayoutConstraint!
    
    @IBOutlet weak open var foregroundView: BmmRotatedView!
    @IBOutlet weak open var foregroundViewTop: NSLayoutConstraint!
    
    var animationView: UIView?
    
    @IBInspectable open var itemCount: NSInteger = 2
    @IBInspectable open var backViewColor: UIColor = UIColor.brown
    
    var animationItemViews: [BmmRotatedView]?
    
    public enum AnimationType {
        case open
        case close
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
    
    open func commonInit() {
        configureDefaultState()
        
        selectionStyle = .none
        
        detailView.layer.cornerRadius = foregroundView.layer.cornerRadius
        detailView.layer.masksToBounds = true
    }
    
    func configureDefaultState() {
        guard let foregroundViewTop = foregroundViewTop else {
            fatalError("set constraint outlets please!")
        }
        detailViewTop.constant = foregroundViewTop.constant
        detailView.alpha = 0
        
        if let height = (foregroundView.constraints.filter {
            $0.firstAttribute == .height &&
            $0.secondItem == nil
        }).first?.constant {
            foregroundView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
            foregroundViewTop.constant += height / 2
        }
        foregroundView.layer.transform = foregroundView.transform3d()
        
        createAnimationView();
        contentView.bringSubview(toFront: foregroundView)
    }
    
    func createAnimationItemView() -> [BmmRotatedView] {
        guard let animationView = animationView else {
            fatalError()
        }
        
        var items = [BmmRotatedView]()
        items.append(foregroundView)
        var rotatedViews = [BmmRotatedView]()
        for case let itemView as BmmRotatedView in animationView.subviews.filter({
            $0 is BmmRotatedView
        }).sorted(by: {$0.tag < $1.tag}) {
            rotatedViews.append(itemView)
            if let backView = itemView.backView {
                rotatedViews.append(backView)
            }
        }
        items.append(contentsOf: rotatedViews)
        return items
    }
    
    func configureAnimationItems(_ animationType: AnimationType) {
        guard let animationViewSuperView = animationView?.subviews else {
            fatalError()
        }
        
        if animationType == .open {
            for view in animationViewSuperView.filter({$0 is BmmRotatedView}) {
                view.alpha = 0
            }
        } else {
            for case let view as BmmRotatedView in animationViewSuperView.filter({
                $0 is BmmRotatedView
            }) {
                if animationType == .open {
                    view.alpha = 0
                } else {
                    view.alpha = 1
                    view.backView?.alpha = 0
                }
            }
        }
    }
    
    func createAnimationView() {
        animationView = UIView(frame: detailView.frame)
        animationView?.layer.cornerRadius = foregroundView.layer.cornerRadius
        animationView?.backgroundColor = .clear
        animationView?.translatesAutoresizingMaskIntoConstraints = false
        animationView?.alpha = 0
        
        guard let animationView = animationView else {
            return
        }
        
        contentView.addSubview(animationView)
        
        var newConstraints = [NSLayoutConstraint]()
        for constraint in contentView.constraints {
            if let item = constraint.firstItem as? UIView, item == detailView {
                let newConstraint =
                    NSLayoutConstraint(item: animationView,
                                       attribute: constraint.firstAttribute,
                                       relatedBy: constraint.relation,
                                       toItem: constraint.secondItem,
                                       attribute: constraint.secondAttribute,
                                       multiplier: constraint.multiplier,
                                       constant: constraint.constant)
                
                newConstraints.append(newConstraint)
            } else if let item: UIView = constraint.secondItem as? UIView, item == detailView {
                let newConstraint =
                    NSLayoutConstraint(item: constraint.firstItem,
                                       attribute: constraint.firstAttribute,
                                       relatedBy: constraint.relation,
                                       toItem: animationView,
                                       attribute: constraint.secondAttribute,
                                       multiplier: constraint.multiplier,
                                       constant: constraint.constant)
                
                newConstraints.append(newConstraint)
            }
        }
        contentView.addConstraints(newConstraints)
        
        for constraint in detailView.constraints {
            if constraint.firstAttribute == .height {
                let newConstraint =
                    NSLayoutConstraint(item: animationView,
                                       attribute: constraint.firstAttribute,
                                       relatedBy: constraint.relation,
                                       toItem: nil,
                                       attribute: constraint.secondAttribute,
                                       multiplier: constraint.multiplier,
                                       constant: constraint.constant)
                
                animationView.addConstraint(newConstraint)
            }
        }
    }
    
    func addImageItemsToAnimationView() {
        detailView.alpha = 1
        let detSize = detailView.bounds.size
        let forgSize = foregroundView.bounds.size
        
        var image = detailView.BmmTakeSnapshot(CGRect(x: 0, y: 0, width: detSize.width, height: forgSize.height))
        var imageView = UIImageView(image: image)
        
        imageView.tag = 0
        imageView.layer.cornerRadius = foregroundView.layer.cornerRadius
        animationView?.addSubview(imageView)
        
        image = detailView.BmmTakeSnapshot(CGRect(x: 0, y: forgSize.height, width: detSize.width, height: forgSize.height))
        
        imageView = UIImageView(image: image)
        let rotatedView = BmmRotatedView(frame: imageView.frame)
        rotatedView.tag = 1
        rotatedView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0)
        rotatedView.layer.transform = rotatedView.transform3d()
        
        rotatedView.addSubview(imageView)
        animationView?.addSubview(rotatedView)
        rotatedView.frame = CGRect(x: imageView.frame.origin.x, y: forgSize.height, width: detSize.width, height: forgSize.height)
        
        let itemHeight = (detSize.height - 2 * forgSize.height) / CGFloat(itemCount - 2)
        
        if itemCount == 2 {
            assert(detSize.height - 2 * forgSize.height == 0, "detailView.height too high")
        }
        
        assert(detSize.height - 2 * forgSize.height >= itemHeight, "contanerView.height too high")
        
        var yPosition = 2 * forgSize.height
        var tag = 2
        for _ in 2..<itemCount {
            image = detailView.BmmTakeSnapshot(CGRect(x: 0, y: yPosition, width: detSize.width, height: itemHeight))
            
            imageView = UIImageView(image: image)
            let rotatedView = BmmRotatedView(frame: imageView.frame)
            
            rotatedView.addSubview(imageView)
            rotatedView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0)
            rotatedView.layer.transform = rotatedView.transform3d()
            animationView?.addSubview(rotatedView)
            rotatedView.frame = CGRect(x: 0, y: yPosition, width: rotatedView.bounds.size.width, height: itemHeight)
            rotatedView.tag = tag
            
            yPosition += itemHeight
            tag += 1;
        }
        
        detailView.alpha = 0;
        
        if let animationView = animationView {
            // added back view
            var previusView: BmmRotatedView?
            for case let contener as BmmRotatedView in animationView.subviews.sorted(by: { $0.tag < $1.tag })
                where contener.tag > 0 && contener.tag < animationView.subviews.count {
                    previusView?.addBackView(contener.bounds.size.height, color: backViewColor)
                    previusView = contener
            }
        }
        animationItemViews = createAnimationItemView()
    }
    
    fileprivate func removeImageItemsFromAnimationView() {
        
        guard let animationView = self.animationView else {
            return
        }
        
        animationView.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    open func selectedAnimation(_ isSelected: Bool, animated: Bool, completion: ((Void) -> Void)?) {
        
        if isSelected {
            
            if animated {
                detailView.alpha = 0;
                openAnimation(completion)
            } else  {
                foregroundView.alpha = 0
                detailView.alpha = 1;
            }
            
        } else {
            if animated {
                closeAnimation(completion)
            } else {
                foregroundView.alpha = 1;
                detailView.alpha = 0;
            }
        }
    }
    
    open func isAnimating()->Bool {
        return animationView?.alpha == 1 ? true : false
    }
    
    // MARK: animations
    open func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
        assert(false, "added this method to cell")
        return 0
    }
    
    func durationSequence(_ type: AnimationType)-> [TimeInterval] {
        var durations  = [TimeInterval]()
        for index in 0..<itemCount-1 {
            let duration = animationDuration(index, type: .open)
            durations.append(TimeInterval(duration / 2.0))
            durations.append(TimeInterval(duration / 2.0))
        }
        return durations
    }
    
    func openAnimation(_ completion: ((Void) -> Void)?) {
        
        removeImageItemsFromAnimationView()
        addImageItemsToAnimationView()
        
        guard let animationView = self.animationView else {
            return
        }
        
        animationView.alpha = 1;
        detailView.alpha = 0;
        
        let durations = durationSequence(.open)
        
        var delay: TimeInterval = 0
        var timing                = kCAMediaTimingFunctionEaseIn
        var from: CGFloat         = 0.0;
        var to: CGFloat           = CGFloat(-M_PI / 2)
        var hidden                = true
        configureAnimationItems(.open)
        
        guard let animationItemViews = animationItemViews else {
            return
        }
        
        for index in 0..<animationItemViews.count {
            let animatedView = animationItemViews[index]
            
            animatedView.animation(timing, from: from, to: to, duration: durations[index], delay: delay, hidden: hidden)
            
            from   = from == 0.0 ? CGFloat(M_PI / 2) : 0.0;
            to     = to == 0.0 ? CGFloat(-M_PI / 2) : 0.0;
            timing = timing == kCAMediaTimingFunctionEaseIn ? kCAMediaTimingFunctionEaseOut : kCAMediaTimingFunctionEaseIn;
            hidden = !hidden
            delay += durations[index]
        }
        
        let firstItemView = animationView.subviews.filter{$0.tag == 0}.first
        
        firstItemView?.layer.masksToBounds = true
        DispatchQueue.main.asyncAfter(deadline: .now() + durations[0], execute: {
            firstItemView?.layer.cornerRadius = 0
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            self.animationView?.alpha = 0
            self.detailView.alpha  = 1
            completion?()
        })
    }
    
    func closeAnimation(_ completion: ((Void) -> Void)?) {
        
        removeImageItemsFromAnimationView()
        addImageItemsToAnimationView()
        
        guard let animationItemViews = self.animationItemViews else {
            fatalError()
        }
        
        animationView?.alpha = 1;
        detailView.alpha  = 0;
        
        var durations: [TimeInterval] = durationSequence(.close).reversed()
        
        var delay: TimeInterval = 0
        var timing                = kCAMediaTimingFunctionEaseIn
        var from: CGFloat         = 0.0;
        var to: CGFloat           = CGFloat(M_PI / 2)
        var hidden                = true
        configureAnimationItems(.close)
        
        if durations.count < animationItemViews.count {
            fatalError("wrong override func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval")
        }
        for index in 0..<animationItemViews.count {
            let animatedView = animationItemViews.reversed()[index]
            
            animatedView.animation(timing, from: from, to: to, duration: durations[index], delay: delay, hidden: hidden)
            
            to     = to == 0.0 ? CGFloat(M_PI / 2) : 0.0;
            from   = from == 0.0 ? CGFloat(-M_PI / 2) : 0.0;
            timing = timing == kCAMediaTimingFunctionEaseIn ? kCAMediaTimingFunctionEaseOut : kCAMediaTimingFunctionEaseIn;
            hidden = !hidden
            delay += durations[index]
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            self.animationView?.alpha = 0
            completion?()
        })
        
        let firstItemView = animationView?.subviews.filter{$0.tag == 0}.first
        firstItemView?.layer.cornerRadius = 0
        firstItemView?.layer.masksToBounds = true
        if let durationFirst = durations.first {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay - durationFirst * 2, execute: {
                firstItemView?.layer.cornerRadius = self.foregroundView.layer.cornerRadius
                firstItemView?.setNeedsDisplay()
                firstItemView?.setNeedsLayout()
            })
        }
    }

}
