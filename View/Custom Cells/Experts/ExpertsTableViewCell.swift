//
//  ExpertsTableViewCell.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 29/06/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit

class ExpertsTableViewCell: UITableViewCell {

    @IBOutlet weak var expertsImg: UIImageView!
    @IBOutlet weak var expertName: UILabel!
    @IBOutlet weak var expertsOrgName: UILabel!
    @IBOutlet weak var expertsDescri: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        Utility.setBorderAndCornerRadius(object:self.expertsImg.layer, width: 2, radius: self.expertsImg.frame.size.height / 2, color: UIColor.gray)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ExpertsTableViewCell {
    
    func setupCell() {
        
        
    }
}
