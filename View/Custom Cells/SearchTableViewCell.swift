//
//  SearchTableViewCell.swift
//  ArtGenies
//
//  Created by Abhay Bachche on 12/09/19.
//  Copyright © 2019 Abhay Bachche. All rights reserved.
//

import UIKit




protocol SearchTableViewCellDelegate {
    
    func searchResultTapped(cell:SearchTableViewCell,indexPath:IndexPath,identifyVCCell:String)
    func showMoreBtnTapped(cell:SearchTableViewCell,indexPath:IndexPath,identifyVCCell:String)
    func keyboardHide(cell: SearchTableViewCell)
}

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet var BgView: UIView!
    @IBOutlet var searchTableViewCellheight: NSLayoutConstraint!
    @IBOutlet var showMoreBtn: UIButton!
    @IBOutlet weak var sectiontableView: UICollectionView!
    @IBOutlet weak var sectionNameLbl: UILabel!
    var indexPath: IndexPath!
    var searchdetail:SearchDetails? = nil
    var delegate : SearchTableViewCellDelegate?
    var ExhibitionsArray = [ExhibitionsLists]()
    var GalleryListsArray = [GalleryLists]()
    var ArtistsArtsArray = [Artists]()
    var identifyVCCell: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tapGesture.numberOfTapsRequired = 1
        BgView.addGestureRecognizer(tapGesture)
        
        
        self.sectiontableView.register(UINib(nibName: "ExhibitionCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ExhibitionCollectionViewCell")
        self.sectiontableView.register(UINib(nibName: "ArtistSearchCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ArtistSearchCollectionViewCell")
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    
    @IBAction func ShowMoreBtn_Tapped(_ sender: Any) {
        
        self.delegate?.showMoreBtnTapped(cell: self, indexPath: indexPath, identifyVCCell: identifyVCCell)
    }
    
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.delegate?.keyboardHide(cell: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.delegate?.keyboardHide(cell: self)
    }
}

extension SearchTableViewCell
{
    func setupCell(index:Int,searchdetail:SearchDetails,identifyVCCell:String)
    {
        self.identifyVCCell = identifyVCCell
        self.searchdetail = searchdetail
        
        //                if identifyVCCell == "ExhibitionTableCell" && self.searchdetail!.exhibitions.count > 0 {
        //                    self.sectionNameLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "exhibition", comment: "")
        //                    self.showMoreBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "showmore", comment: ""), for: .normal)
        //                    self.ExhibitionsArray = searchdetail.exhibitions
        //                }
        
        if identifyVCCell == "ExhibitionTableCell" {
            
            self.sectionNameLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "exhibition", comment: "")
            
            if self.searchdetail!.exhibitions.count > 5 {
                self.showMoreBtn.isHidden = false
                self.showMoreBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "showmore", comment: ""), for: .normal)
            }
            else if self.searchdetail!.exhibitions.count == 0 {
                self.showMoreBtn.setTitle("", for: .normal)
                self.sectionNameLbl.text = ""
            }
            self.ExhibitionsArray = searchdetail.exhibitions
            
        }
            
        else if identifyVCCell == "GalleryCollectionCell" {
            
             self.sectionNameLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "gallery", comment: "")
            
        if self.searchdetail!.galleries.count >= 5 {
              self.showMoreBtn.isHidden = false
           
            self.showMoreBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "showmore", comment: ""), for: .normal)
            
        }
        else if self.searchdetail!.galleries.count == 0 {
            self.showMoreBtn.setTitle("", for: .normal)
            self.sectionNameLbl.text = ""
            }
            self.GalleryListsArray = searchdetail.galleries
        }
            
            
            
            //        else if identifyVCCell == "GalleryCollectionCell" && self.searchdetail!.galleries.count > 0 {
            //            self.sectionNameLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "gallery", comment: "")
            //            self.showMoreBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "showmore", comment: ""), for: .normal)
            //            self.GalleryListsArray = searchdetail.galleries
            //        }
            
            
        else if identifyVCCell == "ArtCollectionViewCell" {
            
              self.sectionNameLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "trending_arts", comment: "")
         if self.searchdetail!.arts.count >= 5 {
            self.showMoreBtn.isHidden = false
          
            self.showMoreBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "showmore", comment: ""), for: .normal)
            }
         else if self.searchdetail!.arts.count == 0 {
            self.showMoreBtn.setTitle("", for: .normal)
            self.sectionNameLbl.text = ""
            }
            self.ArtistsArtsArray = searchdetail.arts
        }
            
//        else {
//
//
//        }
        
        self.sectiontableView.reloadData()
        
    }
}

extension SearchTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch identifyVCCell {
        case "ExhibitionTableCell":
            return self.ExhibitionsArray.count
        case "GalleryCollectionCell":
            return self.GalleryListsArray.count
        case "ArtCollectionViewCell":
            return self.ArtistsArtsArray.count
        default:
            break
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch identifyVCCell {
        case "ExhibitionTableCell":
            let cell:ExhibitionCollectionViewCell = self.sectiontableView.dequeueReusableCell(withReuseIdentifier: "ExhibitionCollectionViewCell", for: indexPath) as! ExhibitionCollectionViewCell
            Utility.NVActivityStartAnimation(cell.programmImg!)
            cell.setupCellExhibition(exhibition: ExhibitionsArray[indexPath.row])
            return cell
        case "GalleryCollectionCell":
            let cell:ExhibitionCollectionViewCell = self.sectiontableView.dequeueReusableCell(withReuseIdentifier: "ExhibitionCollectionViewCell", for: indexPath) as! ExhibitionCollectionViewCell
            Utility.NVActivityStartAnimation(cell.programmImg!)
            cell.setupCellGallery(gallery: GalleryListsArray[indexPath.row])
            return cell
        case "ArtCollectionViewCell":
            let cell:ArtistSearchCollectionViewCell = self.sectiontableView.dequeueReusableCell(withReuseIdentifier: "ArtistSearchCollectionViewCell", for: indexPath) as! ArtistSearchCollectionViewCell
            Utility.NVActivityStartAnimation(cell.artistImg!)
            cell.setupCellArts(arts:ArtistsArtsArray[indexPath.row])
            return cell
        default:
            break
        }
        return UICollectionViewCell.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //  return CGSize(width: self.sectiontableView.frame.size.width / 2, height: self.sectiontableView.frame.size.height)
        
        let padding: CGFloat =  5
        let collectionViewSize = sectiontableView.frame.size.width - padding
        return CGSize(width:  sectiontableView.frame.size.width / 2, height: self.sectiontableView.frame.size.height )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.delegate?.searchResultTapped(cell: self, indexPath: indexPath, identifyVCCell: identifyVCCell)
        
    }
}

