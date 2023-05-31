//
//  WorksArtistCollectionViewCell.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 07/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit

class WorksArtistCollectionViewCell: UICollectionViewCell {
    
   
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistImg: UIImageView!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        Utility.setBorderAndCornerRadius(object:self.bgView.layer, width: 1, radius:0,color: UIColor.gray)
    }

}

extension WorksArtistCollectionViewCell {
    func setupCell(artist:Artists) {
        if let name = artist.name {
            self.artistName.text = name
        }
        if let urlStringtp = artist.thumb_path {
            self.artistImg.sd_setImage(with: URL(string: urlStringtp), placeholderImage: UIImage(contentsOfFile: ""))
        }
    }
    func setupCell1(artist:UserOwnedDetails) {
        if let name = artist.name {
            self.artistName.text = name
        }
         let urlStringtp = artist.thumb_path
        self.artistImg.sd_setImage(with: URL(string: urlStringtp!), placeholderImage: UIImage(contentsOfFile: ""))
    }
}
