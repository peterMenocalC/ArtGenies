//
//  UserGuideCollectionViewCell.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 04/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit

class UserGuideCollectionViewCell: UICollectionViewCell {

    @IBOutlet var iconImg: UIImageView!
    @IBOutlet weak var titleHeadingLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet var agreeBtn: UIButton!
    @IBOutlet var agreeBtnHeight: NSLayoutConstraint!
    @IBOutlet var agreeBtnWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        self.agreeBtn.isHidden = true
        self.agreeBtnHeight.constant = 0
        
          self.agreeBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "iagree", comment: ""), for: .normal)
        
        
      
        
        Utility.setBorderAndCornerRadius(object:self.agreeBtn.layer, width: 1, radius:0,color: UIColor.white)
    }

}
extension UserGuideCollectionViewCell {
    
    func setupCell(userguide:Userguide,indexpath:Int) {
        
        self.titleHeadingLbl.text = userguide.userguidename
        self.descLbl.text = userguide.userguidedesc
        
        let img = UIImage.init(named: userguide.icon!)?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        
        self.iconImg.image = img
        self.iconImg.tintColor = .white
        
        if indexpath == 2 {
            if self.agreeBtn.titleLabel?.text == "Je suis d’accord" {
                self.agreeBtnWidth.constant = 145
            }
            self.agreeBtn.isHidden = false
            self.agreeBtnHeight.constant = 30
        }
    }
}
