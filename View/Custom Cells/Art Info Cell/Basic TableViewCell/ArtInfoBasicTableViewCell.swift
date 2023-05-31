//
//  ArtInfoBasicTableViewCell.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 16/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit

protocol ArtInfoBasicTableViewCellDelegate {
    
    
    func favoriteBtnTapped(cell:ArtInfoBasicTableViewCell,indexPath:IndexPath)
    func readMoreTapped(cell:ArtInfoBasicTableViewCell,indexPath:IndexPath)
    func goToArtDetail(cell:ArtInfoBasicTableViewCell,indexPath:IndexPath)
    func artShareTapped(cell:ArtInfoBasicTableViewCell,indexPath:IndexPath)
    func downloadTapped(cell:ArtInfoBasicTableViewCell,indexPath:IndexPath)
}

class ArtInfoBasicTableViewCell: UITableViewCell {
    
    var ownerViewStatus = false
    var indexPath: IndexPath!
    var delegate : ArtInfoBasicTableViewCellDelegate?
    
   
    
    @IBOutlet weak var artInfoNameLbl: UILabel!
    @IBOutlet weak var artInfoDesc: UILabel!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var favouriteLbl: UILabel!
    @IBOutlet weak var artShareLbl: UILabel!
    @IBOutlet weak var artistNameLbl: UIButton!
    @IBOutlet weak var readMoreBtn: UIButton!
    @IBOutlet weak var ownerView: UIView!
    @IBOutlet weak var ownerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var wriittername: UILabel!
    @IBOutlet weak var readAndViewVerticalConstant: NSLayoutConstraint!
    @IBOutlet weak var readMoreBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var readMoreBtnBottomHeightConstraint: NSLayoutConstraint!
    @IBOutlet var downloadCountLbl: UILabel!
    
    @IBOutlet var prixLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
     Utility.setBorderAndCornerRadius(object:self.profileImg.layer, width: self.profileImg.frame.size.width / 2, radius: self.profileImg.frame.size.height / 2, color: UIColor.clear)
        
     self.readMoreBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "read_more", comment: ""), for: .normal)
        
    // self.prixLbl.text =
        
        // Initialization code
//        artInfoDesc.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func FavoriteBtn_Tapped(_ sender: Any) {
        
        self.delegate?.favoriteBtnTapped(cell: self, indexPath: indexPath)
    }
    
    @IBAction func ArtShare_Tapped(_ sender: Any) {
        self.delegate?.artShareTapped(cell: self, indexPath: indexPath)
    }
    @IBAction func GotoArtDetail_Tapped(_ sender: Any) {
        self.delegate?.goToArtDetail(cell: self, indexPath: indexPath)
    }
    @IBAction func ReadMore_Tapped(_ sender: Any) {
        self.delegate?.readMoreTapped(cell: self, indexPath: indexPath)
    }
    
    @IBAction func Download_Tapped(_ sender: Any) {
         self.delegate?.downloadTapped(cell: self, indexPath: indexPath)
    }
}

extension ArtInfoBasicTableViewCell {
    
    func setupCell(artinfo:ArtInfoDetails) {
        
        if let name =  artinfo.name {
             if let tagline =  artinfo.tag_line {
                self.artInfoNameLbl.text = name + " " + tagline
            }
             else {
                  self.artInfoNameLbl.text = name
            }
        }
        if let price =  artinfo.price {
            if price == 0 {
                self.prixLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "price", comment: "") + " : -" + LocalizationSystem.sharedInstance.localizedStringForKey(key: "NA", comment: "")
            }
            else {
                self.prixLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "price", comment: "")+" : €"+String(price)
            }
        }
        if let favoritecount =  artinfo.favorite_count {
            self.favouriteLbl.text = String(favoritecount)
        }
        
        if let sharecount =  artinfo.share_count {
            self.artShareLbl.text = String(sharecount)
        }
         if let downloadcount =  artinfo.download_count {
            
            self.downloadCountLbl.text = String(downloadcount)
            
        }
        if let arttistname =  artinfo.artist.name {
            self.artistNameLbl.setTitle("   \(arttistname)", for: .normal)
        }
        if let desc = artinfo.descriptions[0].description {
            
            self.artInfoDesc.text = desc
        }
        if let wriittername = artinfo.descriptions[0].artists!.name
         {
            self.wriittername.text = wriittername
            
        }
        if let desc = artinfo.descriptions[0].description {
            
            self.artInfoDesc.text = desc
        }
        if let wriitterimgurl = artinfo.descriptions[0].artists.thumb_path {
            self.profileImg.sd_setImage(with: URL(string: wriitterimgurl), placeholderImage: UIImage(contentsOfFile: ""))
        }
        
    
        if self.ownerViewStatus == false {
            self.ownerView.isHidden = true
            //readAndViewVerticalConstant.constant = -8.0
            self.ownerViewHeightConstraint.constant = 0
        }
        else {
            self.ownerView.isHidden = false
            readAndViewVerticalConstant.constant = 2.0
            self.ownerViewHeightConstraint.constant = 55.0
        }
        
        if Utility.calculateMaxLines(self.artInfoDesc!) <= 5 {
            
            readMoreBtnHeightConstraint.constant = 0
            readMoreBtnBottomHeightConstraint.constant = 0
            self.readMoreBtn.isHidden = true
        }
    }
}
