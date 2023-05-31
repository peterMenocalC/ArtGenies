//
//  OwnershipHistoryTableViewCell.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 17/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit

class OwnershipHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ownerimg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ownerDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Utility.setBorderAndCornerRadius(object:self.ownerimg.layer, width: self.ownerimg.frame.size.width / 2, radius: self.ownerimg.frame.size.height / 2, color: UIColor.clear)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension OwnershipHistoryTableViewCell {
    
    func setupCellOwnership(owners:OwnersDetail) {
        
        if let form =  owners.from{
            if let to =  owners.to {
                self.ownerDate.text = Utility.UnixToDateString(timeStamp: form, dateFormat: Utility.DateFormat.Date) + "-" +
                    Utility.UnixToDateString(timeStamp: to, dateFormat: Utility.DateFormat.Date)
            }
        }
        
        if let name =  owners.Owner.name {
            self.nameLbl.text = name
        }
        
        if let urlStringfp = owners.Owner.thumb_path {
            self.ownerimg.sd_setImage(with: URL(string: urlStringfp), placeholderImage: UIImage(contentsOfFile: ""))
        }
    }
    
    func setupCellExhibition(exhibition:ExhibitionsDetail) {
        
     
        self.ownerDate.text = "-"
        
        if let name =  exhibition.artists.name {
            self.nameLbl.text = name
        }
        
        if let urlStringfp = exhibition.artists.thumb_path {
            self.ownerimg.sd_setImage(with: URL(string: urlStringfp), placeholderImage: UIImage(contentsOfFile: ""))
        }
    }
}


