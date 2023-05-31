//
//  GalleryStatusTableViewCell.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 20/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit

class GalleryStatusTableViewCell: UITableViewCell {

    
    @IBOutlet weak var galleryName: UILabel!
    @IBOutlet weak var galleryImg: UIImageView!
    
    @IBOutlet weak var galleryStatus: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        Utility.setBorderAndCornerRadius(object:self.galleryImg.layer, width: self.galleryImg.frame.size.width / 2, radius: self.galleryImg.frame.size.height / 2, color: UIColor.clear)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension GalleryStatusTableViewCell {
    
    func setupCell(artinfo:GalleryLists) {
        
        if let name = artinfo.name {
            
            self.galleryName.text = name
        }
        if let galleryimgurl = artinfo.thumb_path {
            self.galleryImg.sd_setImage(with: URL(string: galleryimgurl), placeholderImage: UIImage(contentsOfFile: ""))
        }
        
        let formatter12 = DateFormatter()
        formatter12.dateFormat = "hh:mm"
        let timeString12 = formatter12.string(from: NSDate() as Date).replacingOccurrences(of: ":", with: "")
        let time:Double = (Double(timeString12)!/100)
        
        for index in artinfo.timing {
            if index.day_of_week == Date().dayOfWeek() {
                if time > index.closing || time < index.opening {
                    
                    self.galleryStatus.textColor = .green
                    self.galleryStatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "opennowws", comment: "")
                }
                else {
                    
                    self.galleryStatus.textColor = .red
                    self.galleryStatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "closenowws", comment: "")
                }
            }
            else {
                
                self.galleryStatus.textColor = .red
                self.galleryStatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "closenowws", comment: "")
            }
        }
    }
        
}

