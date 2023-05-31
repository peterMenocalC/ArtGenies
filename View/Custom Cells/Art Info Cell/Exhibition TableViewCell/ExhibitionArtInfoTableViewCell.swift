//
//  ExhibitionArtInfoTableViewCell.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 20/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit

protocol ExhibitionArtInfoTableViewCellDelegate {
    
    func upAndDownArrow(cell:ExhibitionArtInfoTableViewCell,indexPath:IndexPath)
}

class ExhibitionArtInfoTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var exbmenuNameLbl: UIButton!
    @IBOutlet weak var exbmenuNameBtn: UIButton!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var exbdaysTableView: UITableView!
    var ExhibitionArray = [ExhibitionsDetail]()
    var identifyVCCell: String!
    var indexPath: IndexPath!
    var delegate : ExhibitionArtInfoTableViewCellDelegate?
   // var galleryDetailsArray:[String] = ["11.jpg","12.jpeg","13.jpg","14.jpg","15.jpg"]
    var CellToExpandOpenToday = false
    var identifyVC: String!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.exbdaysTableView.register(UINib(nibName: "OwnershipHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "OwnershipHistoryTableViewCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func UpAndDownArrow_Tapped(_ sender: Any) {
        self.delegate?.upAndDownArrow(cell: self, indexPath: indexPath)
    }
}

extension ExhibitionArtInfoTableViewCell {
    
    func setupCellExhibition(artinfodetail:ArtInfoDetails) {
        
        if identifyVC == "ArtInfoVC" &&  identifyVCCell == "ExhibitionTableCell" {
         
        self.exbmenuNameLbl.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "exhibition_history", comment: ""), for: .normal)
            
            self.ExhibitionArray = artinfodetail.exhibitions
            
            self.exbdaysTableView.reloadData()
          
        }
    }
    
    func setupHeight() {
        
        if self.CellToExpandOpenToday == false {
            self.exbdaysTableView.isHidden = true
            self.height.constant = 0
            let img1 = UIImage.init(named: "arrow-down")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            self.exbmenuNameBtn.setImage(img1, for: .normal)
            self.exbmenuNameBtn.tintColor = .darkGray
            self.contentView.setNeedsUpdateConstraints()
        }
    }
}

extension ExhibitionArtInfoTableViewCell : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ExhibitionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OwnershipHistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "OwnershipHistoryTableViewCell") as! OwnershipHistoryTableViewCell
        cell.setupCellExhibition(exhibition:self.ExhibitionArray[indexPath.row])
        return cell
    }
    
    
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        //1. Setup the CATransform3D structure
    //        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
    //        UIView.animate(withDuration: 0.3, animations: {
    //            cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
    //        },completion: { finished in
    //            UIView.animate(withDuration: 0.1, animations: {
    //                cell.layer.transform = CATransform3DMakeScale(1,1,1)
    //            })
    //        })
    //    }
}
