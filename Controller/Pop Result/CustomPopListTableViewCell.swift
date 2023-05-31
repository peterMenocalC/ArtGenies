//
//  CustomPopListTableViewCell.swift
//  ArtGenies
//
//  Created by Abhay Bachche on 13/09/19.
//  Copyright © 2019 Abhay Bachche. All rights reserved.
//

import UIKit

class CustomPopListTableViewCell: UITableViewCell {
    
    
    @IBOutlet var srNumber: UILabel!
    @IBOutlet var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
         Utility.setBorderAndCornerRadius(object:self.srNumber.layer, width: 0, radius: self.srNumber.frame.size.height / 2, color: UIColor.clear)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CustomPopListTableViewCell {
    
    func setupCell(indexs:Indexs) {
 
        if let description = indexs.description {
            self.nameLbl.text = description
        }
        if let number = indexs.seriesnumber {
            self.srNumber.text = number
        }
    }
}
