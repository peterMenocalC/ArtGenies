//
//  ArtistInfotableViewCell.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 07/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit

protocol ArtistInfotableViewCellDelegate {
    func readMoreTapped(cell:ArtistInfotableViewCell,indexPath:IndexPath)
}

class ArtistInfotableViewCell: UITableViewCell {

    var indexPath:IndexPath!
    var delegate : ArtistInfotableViewCellDelegate?
    @IBOutlet weak var artistImg: UIImageView!
    @IBOutlet weak var artistNameLbl: UILabel!
    @IBOutlet weak var artistDescLbl: UILabel!
    @IBOutlet weak var ReadmoreBtn: UIButton!
    
    @IBOutlet weak var readMoreBtnTop: NSLayoutConstraint!
    @IBOutlet weak var readMoreBtnHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //Utility.setBorderAndCornerRadius(object:self.artistImg.layer, width: 2, radius:0,color: UIColor.gray)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func Readmore_Tapped(_ sender: Any) {
           self.delegate?.readMoreTapped(cell: self, indexPath: indexPath)
    }
}

extension ArtistInfotableViewCell
{
    func setupCell(artistdetail:ArtistDetails){
        
        if let artisturlstring = artistdetail.full_path {
         self.artistImg.sd_setImage(with: URL(string: artisturlstring), placeholderImage: UIImage(contentsOfFile: ""))


        }
        if let artistname = artistdetail.name {
            self.artistNameLbl.text = artistname
        }
        if let desc = artistdetail.bio {
   
            
            self.artistDescLbl.text = desc
        }
        
        if Utility.calculateMaxLines(self.artistDescLbl!) <= 3 {
            
            readMoreBtnHeight.constant = 0
//            readMoreBtnTop.constant = 0
            self.ReadmoreBtn.isHidden = true
        }
    }
}

