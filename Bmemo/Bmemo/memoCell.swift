//
//  memoCell.swift
//  Bmemo
//
//  Created by Ama on 11/24/16.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit

class memoCell: BmmTableViewCell {

    @IBOutlet weak var foreImageView: UIImageView!
    @IBOutlet weak var gregorianCalendar: UILabel!
    @IBOutlet weak var lunarCalendar: UILabel!
    
    
    @IBOutlet weak var detImageView: UIImageView!
    @IBOutlet weak var niName: UILabel!
    @IBOutlet weak var alertDate: UILabel!
    
    @IBOutlet weak var detGregorianCalendar: UILabel!
    @IBOutlet weak var detlunarCalendar: UILabel!
    
    @IBOutlet weak var niNameBtn: UIButton!
    
    var photo: UIImage? = nil {
        didSet {
            foreImageView.image = photo
            detImageView.image = photo
        }
    }
    
    var nname: String? = nil {
        didSet {
            niName.text = nname
        }
    }
    
    var aDate: Date? = nil {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
            alertDate.text = formatter.string(from: aDate!)
        }
    }
    
    var dCalendar: String? = nil {
        didSet {
            gregorianCalendar.text = dCalendar
            detGregorianCalendar.text = dCalendar
        }
    }
    
    var lCalendar: String? = nil {
        didSet {
            lunarCalendar.text = lCalendar
            detlunarCalendar.text = lCalendar
        }
    }
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        
        super.awakeFromNib()
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type: BmmTableViewCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    
    func dataFromCell(members: BmmMembers, idx: Int) {
        photo = UIImage(named: "photo")?.drawHeaderImage()
        nname = members.niName
        aDate = members.alarmDate
        dCalendar = members.gregorianCalendar
        lCalendar = members.lunarCalendar
        
        niNameBtn.tag = idx
    }
    
}
