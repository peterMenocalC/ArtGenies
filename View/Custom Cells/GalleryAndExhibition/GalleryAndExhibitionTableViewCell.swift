//
//  GalleryAndExhibition TableViewCell.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 30/06/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit
import SDWebImage

protocol GalleryAndExhibitionTableViewDelegate {
    
    func selectedGalleryId(cell:GalleryAndExhibitionTableViewCell,indexPath:IndexPath)
}

class GalleryAndExhibitionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var galleryImg: UIImageView!
    @IBOutlet weak var galleryName: UILabel!
    @IBOutlet weak var galleryStatus: UILabel!
    var galleryorexhibition:String!
    var currentTimeStamp:Int!
    var indexPath: IndexPath!
    var delegate : GalleryAndExhibitionTableViewDelegate?
    override func awakeFromNib() {
        
        self.currentTimeStamp = Int(Utility.getCurrentTimeInMilliSec())
        
        super.awakeFromNib()
       Utility.setBorderAndCornerRadius(object:self.bgView.layer, width: 1, radius:0,color: UIColor.gray)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        bgView.addGestureRecognizer(tapGesture)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.delegate?.selectedGalleryId(cell: self, indexPath: indexPath)
    }
}

extension GalleryAndExhibitionTableViewCell
{
    func setupCell(gallery:GalleryLists){
        
        if  galleryorexhibition == EXHIBITIONS {
            
            if let galleryName = gallery.name {
                self.galleryName.text = galleryName
            }
            
            if let urlString = gallery.full_path {
                
                self.galleryImg.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(contentsOfFile: ""))

            }
            
            if let startDate = gallery.start_date {
                if let endDate = gallery.end_date {
                    
                    if startDate > self.currentTimeStamp {
                        
                        self.galleryStatus.isHidden = false
                        
                        self.galleryStatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "upcomingws", comment: "")
                        self.galleryStatus.textColor  = UIColor.green
                    }
                    else if startDate < self.currentTimeStamp && endDate > self.currentTimeStamp {
                        
                        self.galleryStatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ongoingws", comment: "")
                        self.galleryStatus.textColor  = UIColor.green
                    }
                    else if endDate < self.currentTimeStamp {
                        
                        self.galleryStatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "completedws", comment: "")
                        
                        self.galleryStatus.textColor  = UIColor.red
                    }
                }
            }
        }
        else {
            
            
            if let urlString = gallery.full_path {
                
                self.galleryImg.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(contentsOfFile: ""))
            }
            if let galleryName = gallery.name {
                self.galleryName.text = galleryName
            }
            let formatter12 = DateFormatter()
            formatter12.dateFormat = "hh:mm"
            let timeString12 = formatter12.string(from: NSDate() as Date).replacingOccurrences(of: ":", with: "")
            let time:Double = (Double(timeString12)!/100)
            
            for index in gallery.timing {
                if index.day_of_week == Date().dayOfWeek() {
                    if time > index.closing || time < index.opening {
                        self.galleryStatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "opennowws", comment: "")
                        self.galleryStatus.textColor  = UIColor.green
                    }
                    else {
                        self.galleryStatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "closenowws", comment: "")
                        self.galleryStatus.textColor  = UIColor.red
                    }
                }
                else {
                    self.galleryStatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "closenowws", comment: "")
                    self.galleryStatus.textColor  = UIColor.red
                }
            }
        }
        
    }
}
