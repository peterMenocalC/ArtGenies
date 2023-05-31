//
//  ManagedPolicyTableViewCell.swift
//  ArtGenies
//
//  Created by Abhay Bachche on 22/09/19.
//  Copyright © 2019 Abhay Bachche. All rights reserved.
//


protocol SettingsSwitchProtocol {
    
    func settingsSwitchValueChanged(_ cell:ManagedPolicyTableViewCell, newValue:Bool,indexPath:IndexPath) -> Void
}


import UIKit

class ManagedPolicyTableViewCell: UITableViewCell {
    
    @IBOutlet var galleryThumbPath: UIImageView!
    @IBOutlet var galleryName: UILabel!
    
    @IBOutlet weak var settingSwitch: UISwitch!
    
    var indexPath:IndexPath!
    var delegate:SettingsSwitchProtocol?
    
    @IBAction func switchValueChanged(_ sender: AnyObject) {
        
        self.delegate?.settingsSwitchValueChanged(self, newValue: self.settingSwitch.isOn, indexPath: indexPath)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
         Utility.setBorderAndCornerRadius(object:self.galleryThumbPath.layer, width: 2, radius: self.galleryThumbPath.frame.size.height / 2, color: UIColor.gray)
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension ManagedPolicyTableViewCell {
    
    func setupCell(getWhitelistGallery:GalleryWhiteList) {
        
        
        print(getWhitelistGallery)
        
        if let galleryName =  getWhitelistGallery.name {
            self.galleryName.text = galleryName
        }
        if let urlString = getWhitelistGallery.thumb_path {
            self.galleryThumbPath.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(contentsOfFile: ""))
        }
        if let notifyMe = getWhitelistGallery.notifyMe {
            if notifyMe == true {
                
                 self.settingSwitch.setOn(notifyMe, animated: false)
            }
            else {
                 self.settingSwitch.setOn(notifyMe, animated: false)
            }
        }
    }
}
