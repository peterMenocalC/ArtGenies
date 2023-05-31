//
//  ArtistSearchCollectionViewCell.swift
//  ArtGenies
//
//  Created by Abhay Bachche on 30/09/19.
//  Copyright © 2019 Abhay Bachche. All rights reserved.
//

import UIKit

class ArtistSearchCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet var BgView: UIView!
    
    @IBOutlet var artistImg: UIImageView!
    @IBOutlet var shareImg: UIImageView!
    @IBOutlet var heartImg: UIImageView!
    
    @IBOutlet var artistName: UILabel!
    @IBOutlet var heartartistCount: UILabel!
    @IBOutlet var shareartistCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
         Utility.setBorderAndCornerRadius(object:self.BgView.layer, width: 1, radius:0,color: UIColor.gray)
        // Initialization code
    }

}

extension ArtistSearchCollectionViewCell {

func setupCellArts(arts:Artists)
{
    if let name =  arts.name {
        self.artistName.text = name
    }
    if let favoritecount =  arts.favorite_count {
        self.heartartistCount.text = String(favoritecount)
    }
    
    if let sharecount =  arts.share_count {
        self.shareartistCount.text = String(sharecount)
    }
    
    if let urlString = arts.thumb_path {
        self.artistImg.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(contentsOfFile: ""))
        Utility.NVActivityStopAnimation()

    }
    }
}
