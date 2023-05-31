//
//  OpenTodayTableViewCell.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 07/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit

protocol OpenTodayTableViewCellDelegate {
    
    func upAndDownArrow(cell:OpenTodayTableViewCell,indexPath:IndexPath,identifyVC:String)
}

class OpenTodayTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var menuNameLbl: UIButton!
    @IBOutlet weak var menuNameBtn: UIButton!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    @IBOutlet var headerView: NSLayoutConstraint!
    
    @IBOutlet var menutopHeight: NSLayoutConstraint!
    @IBOutlet weak var daysTableView: UITableView!
    var exhibitionsDetails:ExhibitionsDetails? = nil
    var indexPath: IndexPath!
    var TimingArray = [TimingDetails]()
    var OwnerArray = [OwnersDetail]()
    var delegate : OpenTodayTableViewCellDelegate?
    var CellToExpandOpenToday = false
    var identifyVCCell: String!
    var galleryorexhibition:String!
    var identifyVC: String!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.daysTableView.register(UINib(nibName: "DateAndTimeWeekTableViewCell", bundle: nil), forCellReuseIdentifier: "DateAndTimeWeekTableViewCell")
        
        self.daysTableView.register(UINib(nibName: "OwnershipHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "OwnershipHistoryTableViewCell")
        
        //
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func UpAndDownArrow_Tapped(_ sender: Any) {
        self.delegate?.upAndDownArrow(cell: self, indexPath: indexPath, identifyVC:identifyVC )
    }
}

extension OpenTodayTableViewCell {
    
    
    func setupCellOwner(artinfodetail:ArtInfoDetails) {
        
        if identifyVC == "ArtInfoVC" &&  identifyVCCell == "OwnershipHTVCell" {
            
            self.OwnerArray = artinfodetail.owners
            
            self.daysTableView.reloadData()
            
            self.menuNameLbl.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "ownership_history", comment: ""), for: .normal)
        }
    }
    
    func setupCellGallery(gallery:GalleryDetails) {
        
        if identifyVC == "GalleryInfoVC" &&  identifyVCCell == "DateAndTimeWeekCell"  && galleryorexhibition == GALLERY_DETAILS {
            self.TimingArray = gallery.timing
            if self.TimingArray.count == 0 {
                headerView.constant = 0
                menuNameLbl.isHidden = true
                
            }
            
            
            let formatter12 = DateFormatter()
            formatter12.dateFormat = "hh:mm"
            let timeString12 = formatter12.string(from: NSDate() as Date).replacingOccurrences(of: ":", with: "")
            let time:Double = (Double(timeString12)!/100)
            
            for index in gallery.timing {
                if index.day_of_week == Date().dayOfWeek() {
                    if time > index.closing || time < index.opening {
                        self.menuNameLbl.setTitleColor(.green, for: .normal)
                    self.menuNameLbl.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "opennow", comment: ""), for: .normal)
                    }
                    else {
                        self.menuNameLbl.setTitleColor(.red, for: .normal)
                    self.menuNameLbl.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "closenow", comment: ""), for: .normal)
                    }
                }
                else {
                    self.menuNameLbl.setTitleColor(.red, for: .normal)
                self.menuNameLbl.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "closenow", comment: ""), for: .normal)
                }
            }
            self.daysTableView.reloadData()
        }
        
    }
    func setupCellExhibition(exhibition:ExhibitionsDetails) {
        
        if identifyVC == "ExhibitionInfoVC" &&  identifyVCCell == "DateAndTimeWeekCell"  && galleryorexhibition == EXHIBITION_DETAILS {
            self.exhibitionsDetails = exhibition
            
            if let startDate = self.exhibitionsDetails?.startdate {
                if let endDate = self.exhibitionsDetails?.enddate {
                    let currentTimeStamp:Int = Int(Utility.getCurrentTimeInMilliSec())
                    if Int(startDate) > currentTimeStamp {
                        self.menuNameLbl.setTitleColor(.green, for: .normal)
                        self.menuNameLbl.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "upcoming", comment: ""), for: .normal)
                        
                    }
                    else if Int(startDate) < currentTimeStamp && Int(endDate) > currentTimeStamp {
                        self.menuNameLbl.setTitleColor(.green, for: .normal)
                        self.menuNameLbl.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "ongoing", comment: ""), for: .normal)
                        
                        
                    }
                    else if Int(endDate) < currentTimeStamp {
                        self.menuNameLbl.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "completed", comment: ""), for: .normal)
                        self.menuNameLbl.setTitleColor(.red, for: .normal)
                        
                    }
                    
                    
                }
            }
        }
        
        self.daysTableView.reloadData()
    }
    func setupHeight() {
        
        if identifyVC == "ArtInfoVC" &&  identifyVCCell == "OwnershipHTVCell" {
            if self.CellToExpandOpenToday == false {
                self.daysTableView.isHidden = true
                self.height.constant = 0
                let img1 = UIImage.init(named: "arrow-down")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                self.menuNameBtn.setImage(img1, for: .normal)
                self.menuNameBtn.tintColor = .darkGray
                self.contentView.setNeedsUpdateConstraints()
            }
        }
        if identifyVC == "GalleryInfoVC" &&  identifyVCCell == "DateAndTimeWeekCell" {
            if self.CellToExpandOpenToday == false {
                self.daysTableView.isHidden = true
                self.height.constant = 0
                let img1 = UIImage.init(named: "arrow-down")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                self.menuNameBtn.setImage(img1, for: .normal)
                self.menuNameBtn.tintColor = .darkGray
                self.contentView.setNeedsUpdateConstraints()
            }
        }
        else if identifyVC == "ExhibitionInfoVC" &&  identifyVCCell == "DateAndTimeWeekCell" {
            if self.CellToExpandOpenToday == false {
                self.daysTableView.isHidden = true
                self.height.constant = 0
                let img1 = UIImage.init(named: "arrow-down")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                self.menuNameBtn.setImage(img1, for: .normal)
                self.menuNameBtn.tintColor = .darkGray
                self.contentView.setNeedsUpdateConstraints()
            }
        }
    }
}

extension OpenTodayTableViewCell : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if galleryorexhibition == GALLERY_DETAILS {
            
            return self.TimingArray.count
        }
        else if galleryorexhibition == EXHIBITION_DETAILS {
            
            return 1
        }
        else {
            
            return  self.OwnerArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell:DateAndTimeWeekTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DateAndTimeWeekTableViewCell") as! DateAndTimeWeekTableViewCell
        
        if  galleryorexhibition == GALLERY_DETAILS {
            cell.setupCellGalleryTime(timing: self.TimingArray[indexPath.row])
        }
        else if identifyVC == "ArtInfoVC" {
            let cell:OwnershipHistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "OwnershipHistoryTableViewCell") as! OwnershipHistoryTableViewCell
            
            cell.setupCellOwnership(owners:self.OwnerArray[indexPath.row])
            
            return cell
        }
        else {
            if let exhibitions = self.exhibitionsDetails {
                cell.setupCellExhibition(exhibition:exhibitions)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
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
