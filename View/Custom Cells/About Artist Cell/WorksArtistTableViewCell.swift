//
//  WorksArtistTableViewCell.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 07/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit
import SDWebImage

protocol WorksArtistTableViewCellDelegate {
    
    func gallerySelected(cell:WorksArtistTableViewCell,indexPath:IndexPath)
}

protocol WorksArtistTableViewCellDelegate1 {
    
    func artsSelected(cell:WorksArtistTableViewCell,indexPath:IndexPath)
}

class WorksArtistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var workArtistCollectionView: UICollectionView!
    @IBOutlet weak var workartistLbl: UILabel!
    @IBOutlet weak var viewMoreBtn: UIButton!
    var identifyVCCell: String!
    var identifyVC: String!
    var delegate : WorksArtistTableViewCellDelegate?
    var delegate1 : WorksArtistTableViewCellDelegate1?
    var indexPath: IndexPath!
    
    // var workArtistArray:[String] = ["1.jpg","2.jpeg","3.jpeg","4.jpeg","5.jpg"]
    var workArtistArray = [Artists]()
    var workAboutArtistArray = [UserOwnedDetails]()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.workArtistCollectionView.register(UINib(nibName: "WorksArtistCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "WorksArtistCollectionViewCell")
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func ViewMoreBtn_Tapped(_ sender: Any) {
        
    }
}

extension WorksArtistTableViewCell {
    
    func setupCell(artist:[Artists]) {
        
        if self.identifyVC == "GalleryInfoVC" &&  self.identifyVCCell == "WorksArtist" {
            self.viewMoreBtn.setTitle("See all", for: UIControl.State.normal)
            self.workArtistArray = artist
            print(self.workArtistArray.count)
            
            if self.workArtistArray.count == 0 {
                self.workartistLbl.isHidden = true
            }
            self.workArtistCollectionView.reloadData()
        }
    }
    func setupCell1(artist:[UserOwnedDetails])
    {
        if self.identifyVC == "AboutArtistVC" &&  self.identifyVCCell == "WorksArtist" {
            
            self.workartistLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "works_by_this_artist", comment: "")
            self.viewMoreBtn.setTitle("See all", for: UIControl.State.normal)
             self.workAboutArtistArray = artist
          
            self.workArtistCollectionView.reloadData()
            
            
        }
    }
}
extension WorksArtistTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if identifyVC == "AboutArtistVC" {
            return self.workAboutArtistArray.count }
        else {
            return self.workArtistArray.count }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:WorksArtistCollectionViewCell = self.workArtistCollectionView.dequeueReusableCell(withReuseIdentifier: "WorksArtistCollectionViewCell", for: indexPath) as! WorksArtistCollectionViewCell
        cell.artistImg!.sd_imageIndicator = SDWebImageActivityIndicator.large
        cell.artistImg!.sd_imageIndicator = SDWebImageActivityIndicator.white
        cell.artistImg!.sd_imageIndicator?.startAnimatingIndicator()
        if identifyVC == "AboutArtistVC" {
            cell.setupCell1(artist:self.workAboutArtistArray[indexPath.row])
            }
        else {
            cell.setupCell(artist:self.workArtistArray[indexPath.row])
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.workArtistCollectionView.frame.size.width / 2.5, height: self.workArtistCollectionView.frame.size.height  )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if identifyVC == "AboutArtistVC" {
             self.delegate1?.artsSelected(cell: self, indexPath: indexPath)
        }
        else {
            self.delegate?.gallerySelected(cell: self, indexPath: indexPath)
        }
    }
    
}


