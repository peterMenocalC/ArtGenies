//
//  GalleryInfoTableViewCell.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 07/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit

protocol GalleryInfoTableViewCellDelegate {
    func readMoreTapped(cell:GalleryInfoTableViewCell,indexPath:IndexPath)
}

class GalleryInfoTableViewCell: UITableViewCell {
    var indexPath: IndexPath!
    var delegate : GalleryInfoTableViewCellDelegate?
  //  var galleryDetails:GalleryDetails!
    
    @IBOutlet weak var galleryImg: UIImageView!
    @IBOutlet weak var galleryThumbImg: UIImageView!
    @IBOutlet weak var galleryName: UILabel!
    @IBOutlet weak var galleryDesc: UILabel!
    @IBOutlet weak var readMoreBtn: UIButton!
    
    @IBOutlet weak var readMoreBtnToptConstant: NSLayoutConstraint!
    @IBOutlet weak var readMoreBtnHeightConstant: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        
      //  Utility.setBorderAndCornerRadius(object:self.galleryImg.layer, width: 2, radius:0,color: Utility.hexStringToUIColor(hex: "9c9c9c"))
        
        
        self.readMoreBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "read_more", comment: ""), for: .normal)
        
        Utility.setBorderAndCornerRadius(object:self.galleryThumbImg.layer, width: 2, radius:self.galleryThumbImg.layer.height/2,color:.clear)
        // Initialization code
        
        // self.galleryDesc.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func ReadMore_Tapped(_ sender: Any) {
         self.delegate?.readMoreTapped(cell: self, indexPath: indexPath)
    }
}

extension GalleryInfoTableViewCell {
    
    func setupCellGallery(gallery:GalleryDetails) {
        
        if let galleryName =  gallery.name {
            self.galleryName.text = galleryName
        }
        if let desc =  gallery.bio {
            self.galleryDesc.text = desc
        }
        if let urlStringfp = gallery.full_path {
            self.galleryImg.sd_setImage(with: URL(string: urlStringfp), placeholderImage: UIImage(contentsOfFile: ""))
            Utility.NVActivityStopAnimation()

            
        }
        
        if let urlStringtp = gallery.thumb_path {
            self.galleryThumbImg.sd_setImage(with: URL(string: urlStringtp), placeholderImage: UIImage(contentsOfFile: ""))
        }
        
        if Utility.calculateMaxLines(self.galleryDesc!) <= 3 {
            
            readMoreBtnToptConstant.constant = 0
            readMoreBtnHeightConstant.constant = 0
            self.readMoreBtn.isHidden = true
        }
    }
    
    func setupCellExhibitions(exhibition:ExhibitionsDetails) {
        
        if let exhibitionName =  exhibition.name {
            self.galleryName.text = exhibitionName
        }
        if let desc =  exhibition.bio {
            self.galleryDesc.text = desc
        }
        if let urlStringfp = exhibition.full_path {
            self.galleryImg.sd_setImage(with: URL(string: urlStringfp), placeholderImage: UIImage(contentsOfFile: ""))
              Utility.NVActivityStopAnimation()
        }
        
        if let urlStringtp = exhibition.thumb_path {
            self.galleryThumbImg.sd_setImage(with: URL(string: urlStringtp), placeholderImage: UIImage(contentsOfFile: ""))
        }
        
        if Utility.calculateMaxLines(self.galleryDesc!) <= 3 {
            
            readMoreBtnToptConstant.constant = 0
            readMoreBtnHeightConstant.constant = 0
            self.readMoreBtn.isHidden = true
        }
    }

}




