//
//  BannerCollectionViewCell.swift
//  ArtGenies
//
//  Created by Abhay Bachche on 12/09/19.
//  Copyright © 2019 Abhay Bachche. All rights reserved.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Utility.setBorderAndCornerRadius(object:self.bgView.layer, width: 2, radius:2, color: UIColor.gray)
        
        // Initialization code
    }

}
