//
//  GalleryDetailsViewController.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 07/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit
import SwiftyJSON
import MaterialShowcase
import SDWebImage


class GalleryDetailsViewController: UIViewController {
    
    
    @IBOutlet var galleryNavigationItem: UINavigationItem!
    @IBOutlet weak var mapBtn: UIBarButtonItem!
    @IBOutlet weak var exhibitionBtn: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var notFoundView: UIView!
    @IBOutlet weak var notFoundLbl: UILabel!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var galleryDetailsTableView: UITableView!
    
    var sequence = MaterialShowcaseSequence()
    
    var galleryDetailsArray:[Int] = [1,2,3,4]
    var CellToExpand = false
    var galleryID:String!
    var galleryorexhibition:String!
    var galleryDetails:GalleryDetails? = nil
    var printsArtsArray = [Artists]()
    var exhibitionsDetails:ExhibitionsDetails? = nil
    var doneButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        if galleryorexhibition == GALLERY_DETAILS {
            self.galleryNavigationItem.rightBarButtonItems = nil
            
            getSelectedGalleries()
            
            
        }
        else {
            getExhibitionGalleries()
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if galleryorexhibition == GALLERY_DETAILS { }
            
        else {
            let showcase1 = MaterialShowcase()
            showcase1.setTargetView(barButtonItem: exhibitionBtn)
            showcase1.primaryText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "programs", comment: "")
            showcase1.secondaryText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "see_programs", comment: "")
            showcase1.isTapRecognizerForTargetView = true
            showcase1.targetTintColor = UIColor.blue
            showcase1.targetHolderRadius = 44
            showcase1.targetHolderColor = UIColor.clear
            showcase1.primaryTextColor = UIColor.white
            showcase1.secondaryTextColor = UIColor.white
            showcase1.primaryTextSize = 30
            showcase1.secondaryTextSize = 20
            showcase1.delegate = self
            
            let showcase2 = MaterialShowcase()
            showcase2.setTargetView(barButtonItem: mapBtn)
            showcase2.primaryText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "map", comment: "")
            showcase1.secondaryText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "internal_map", comment: "")
            showcase2.isTapRecognizerForTargetView = true
            showcase2.targetTintColor = UIColor.blue
            showcase2.targetHolderRadius = 44
            showcase2.targetHolderColor = UIColor.clear
            showcase2.primaryTextColor = UIColor.white
            showcase2.secondaryTextColor = UIColor.white
            showcase2.primaryTextSize = 30
            showcase2.secondaryTextSize = 20
            showcase2.delegate = self
            
            sequence.temp(showcase1).temp(showcase2).setKey(key: "eve2").start()
        }
    }
    
    
    @IBAction func BackBtn_Tapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func ExhibitionProramm_Tapped(_ sender: Any) {
        
        NavigationController.NavigateToExhibitionProgrammers(self,self.exhibitionsDetails!.programmes, self.exhibitionsDetails!.name)
        
    }
    
    @IBAction func InternalMap_Tapped(_ sender: Any) {
        
        NavigationController.NavigateToInternalMap(self,self.exhibitionsDetails!.internalmaps)
        
    }
}


extension GalleryDetailsViewController {
    
    func setupView() {
        
        TitleLbl.text = galleryorexhibition == GALLERY_DETAILS ? LocalizationSystem.sharedInstance.localizedStringForKey(key: "gallery_details", comment: "") : LocalizationSystem.sharedInstance.localizedStringForKey(key: "exhibition_details", comment: "")
        
        
        
        self.galleryDetailsTableView.register(UINib(nibName: "GalleryInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "GalleryInfoTableViewCell")
        self.galleryDetailsTableView.register(UINib(nibName: "OpenTodayTableViewCell", bundle: nil), forCellReuseIdentifier: "OpenTodayTableViewCell")
        self.galleryDetailsTableView.register(UINib(nibName: "DyanmicHyperlinkTableViewCell", bundle: nil), forCellReuseIdentifier: "DyanmicHyperlinkTableViewCell")
        self.galleryDetailsTableView.register(UINib(nibName: "WorksArtistTableViewCell", bundle: nil), forCellReuseIdentifier: "WorksArtistTableViewCell")
    }
}

extension GalleryDetailsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.galleryDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell:GalleryInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GalleryInfoTableViewCell") as! GalleryInfoTableViewCell
            cell.indexPath = indexPath
            cell.delegate = self
            cell.galleryImg.sd_imageIndicator = SDWebImageActivityIndicator.large
            cell.galleryImg.sd_imageIndicator = SDWebImageActivityIndicator.white
            cell.galleryImg.sd_imageIndicator?.startAnimatingIndicator()
            if galleryorexhibition == GALLERY_DETAILS {
                if let gallery = self.galleryDetails {
                    
                    cell.setupCellGallery(gallery:gallery)
                }
            }
            else {
                if let exhibitions = self.exhibitionsDetails {
                    cell.setupCellExhibitions(exhibition:exhibitions)
                }
            }
            return cell
        case 1:  let cell:OpenTodayTableViewCell = tableView.dequeueReusableCell(withIdentifier: "OpenTodayTableViewCell") as! OpenTodayTableViewCell
        cell.indexPath = indexPath
        cell.delegate = self
        cell.identifyVCCell = "DateAndTimeWeekCell"
        cell.galleryorexhibition = galleryorexhibition
        
        
        if galleryorexhibition == GALLERY_DETAILS {
            if let gallery = self.galleryDetails {
                cell.identifyVC = "GalleryInfoVC"
                cell.setupHeight()
                cell.setupCellGallery(gallery:gallery)
            }
        }
        else {
            if let exhibitions = self.exhibitionsDetails {
                cell.identifyVC = "ExhibitionInfoVC"
                cell.setupHeight()
                cell.setupCellExhibition(exhibition:exhibitions)
            }
        }
        return cell
        case 2:
            let cell:DyanmicHyperlinkTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DyanmicHyperlinkTableViewCell") as! DyanmicHyperlinkTableViewCell
            cell.indexPath = indexPath
            cell.delegate = self
            
            if galleryorexhibition == GALLERY_DETAILS {
                if let gallery = self.galleryDetails {
                    cell.setupCellGalleryLink(gallery:gallery)
                    
                }
            }
            else {
                if let exhibitions = self.exhibitionsDetails {
                    cell.setupCellExhibitionLink(exhibition:exhibitions)
                }
            }
            return cell
        case 3:
            let cell:WorksArtistTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WorksArtistTableViewCell") as! WorksArtistTableViewCell
            
            if galleryorexhibition == GALLERY_DETAILS {
                cell.setupCell(artist:printsArtsArray)
                cell.workartistLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "see_gallery_collections", comment: "")
                
            }
            else {
                cell.setupCell(artist:printsArtsArray)
                cell.workartistLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "gallery_participating", comment: "")
                
                
            }
            cell.backgroundColor = Utility.hexStringToUIColor(hex: "0f0f0f")
            cell.indexPath = indexPath
            cell.delegate = self
            cell.identifyVC = "GalleryInfoVC"
            cell.identifyVCCell = "WorksArtist"
            
            return cell
        default:
            break
        }
        
        return UITableViewCell.init()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 1:
            return UITableView.automaticDimension
        case 2:
            if galleryorexhibition == GALLERY_DETAILS {
                if let gallery = self.galleryDetails {
                    if !gallery.weblink.isEmpty {
                        return 70
                    }
                    else {
                        return 5
                    }
                }
            }
            else {
                if let exhibitions = self.exhibitionsDetails {
                    if !exhibitions.weblink.isEmpty {
                        return 70
                    }
                    else {
                        return 5
                    }
                }
            }
            //        case 2:
            //            if galleryorexhibition == GALLERY_DETAILS {
            //                if self.galleryDetails?.timing.count == 0{
            //                    return 0
            //                }
            //                else {
            //                     return 75
            //                }
            //            }
            //            else {
            //                if self.exhibitionsDetails ==  nil {
            //                    return 0
            //                }
            //                else {
            //                     return 75
            //                }
        //            }
        case 3 where self.printsArtsArray.count == 0 :
            return 0
        case 3 where self.printsArtsArray.count != 0 :
            return 235
        default:
            break
        }
        return UITableView.automaticDimension
    }
    
}
extension GalleryDetailsViewController {
    
    func getSelectedGalleries() {
        if Reachability.isConnectedToNetwork() {
            
            Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionAdd)
            
            WebServices.sharedInstance.getSelectedGalleries(galleryID,completionHandler: { (galleriesDetails:JSON,printDetails:JSON,statusCode:Int) -> Void in
                
                Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionRemove)
                
                
                if statusCode == 200 {
                    DispatchQueue.main.async {
                        self.galleryDetails = GalleryDetails(galleryjson: galleriesDetails[DATA])
                        self.printsArtsArray = Artists.getArtistsdetailjson(artistsJSON:printDetails[DATA],ID:UDID)
                        self.galleryDetailsTableView.reloadData()
                    }
                }
                else  if statusCode == 404 {
                    self.notFoundView.isHidden = false
                    self.notFoundLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "gallery_not_found", comment: "")
                }
            })
        }
        else {
            Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_internet", comment: ""), message: "")
        }
    }
    
    func getExhibitionGalleries() {
        if Reachability.isConnectedToNetwork() {
            
            Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionAdd)
            WebServices.sharedInstance.getExhibitionGalleries(galleryID,completionHandler: { (exhibitionDetails:JSON,statusCode:Int) -> Void in
                
                Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionRemove)
                
                if statusCode == 200 {
                    DispatchQueue.main.async {
                        
                        self.exhibitionsDetails = ExhibitionsDetails(exhibitionjson: exhibitionDetails[DATA])
                        self.printsArtsArray = self.exhibitionsDetails!.gallery
                        self.galleryDetailsTableView.reloadData()
                    }
                }
                else if statusCode == 404 {
                    self.notFoundView.isHidden = false
                    self.notFoundLbl.text = "No Exhibition Found"
                }
            })
        }
        else {
            Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_internet", comment: ""), message: "")
        }
    }
}

extension GalleryDetailsViewController:GalleryInfoTableViewCellDelegate,OpenTodayTableViewCellDelegate,DyanmicHyperlinkTableViewCellDelegate,WorksArtistTableViewCellDelegate {
    
    
    
    func hyperlinkCell(cell: DyanmicHyperlinkTableViewCell, indexPath: IndexPath,weblink:String) {
        if let url = URL(string:weblink) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                })
            }
        }
    }
    func upAndDownArrow(cell: OpenTodayTableViewCell, indexPath: IndexPath, identifyVC: String) {
        
        if identifyVC == "GalleryInfoVC" {
            
            if cell.CellToExpandOpenToday == false {
                cell.menuNameBtn.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
                cell.daysTableView.isHidden = false
                cell.CellToExpandOpenToday = true
                cell.height.constant = CGFloat(cell.TimingArray.count * 60 + 05)
                cell.menuNameBtn.tintColor = .darkGray
                cell.daysTableView.reloadData()
                self.galleryDetailsTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                self.galleryDetailsTableView.reloadData()
                cell.contentView.setNeedsUpdateConstraints()
            }
            else {
                cell.menuNameBtn.transform =  CGAffineTransform(rotationAngle: CGFloat(M_PI * 2));
                cell.menuNameBtn.tintColor = .darkGray
                cell.height.constant = 0
                cell.daysTableView.isHidden = true
                cell.CellToExpandOpenToday = false
                cell.daysTableView.reloadData()
                self.galleryDetailsTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                self.galleryDetailsTableView.reloadData()
                cell.contentView.setNeedsUpdateConstraints()
                
            }
        }
        else {
            
            if cell.CellToExpandOpenToday == false {
                cell.menuNameBtn.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
                cell.daysTableView.isHidden = false
                cell.CellToExpandOpenToday = true
                cell.height.constant = CGFloat(1 * 50 + 05)
                cell.menuNameBtn.tintColor = .darkGray
                cell.daysTableView.reloadData()
                self.galleryDetailsTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                self.galleryDetailsTableView.reloadData()
                cell.contentView.setNeedsUpdateConstraints()
            }
            else {
                cell.menuNameBtn.transform =  CGAffineTransform(rotationAngle: CGFloat(M_PI * 2));
                cell.menuNameBtn.tintColor = .darkGray
                cell.height.constant = 0
                cell.daysTableView.isHidden = true
                cell.CellToExpandOpenToday = false
                cell.daysTableView.reloadData()
                self.galleryDetailsTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                self.galleryDetailsTableView.reloadData()
                cell.contentView.setNeedsUpdateConstraints()
                
            }
        }
    }
    func readMoreTapped(cell: GalleryInfoTableViewCell, indexPath: IndexPath) {
        if CellToExpand == false {
            self.readmorelesscell(cell: cell,noOfLines: 0, cellToExpand: true, btnTitle:  LocalizationSystem.sharedInstance.localizedStringForKey(key: "read_less", comment: ""),indexPath:indexPath)
        }
        else {
            self.readmorelesscell(cell: cell,noOfLines: 3, cellToExpand: false, btnTitle:  LocalizationSystem.sharedInstance.localizedStringForKey(key: "read_more", comment: ""),indexPath:indexPath)
        }
    }
    func readmorelesscell (cell:GalleryInfoTableViewCell, noOfLines:Int,cellToExpand:Bool,btnTitle:String,indexPath:IndexPath) {
        cell.galleryDesc.numberOfLines = noOfLines
        cell.galleryDesc.sizeToFit()
        self.galleryDetailsTableView.reloadData()
        self.galleryDetailsTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        CellToExpand = cellToExpand
        cell.readMoreBtn.setTitle(btnTitle, for: .normal)
    }
    
    func gallerySelected(cell: WorksArtistTableViewCell, indexPath: IndexPath) {
        
        if galleryorexhibition == GALLERY_DETAILS {
            NavigationController.NavigateToArtInfo(self,printsArtsArray[indexPath.row].id!,GALLERIES)
        }
        else {
            
            NavigationController.NavigateToGalleryDetails(self,printsArtsArray[indexPath.row].exhibitionid!,GALLERY_DETAILS)
            
        }
    }
}

extension GalleryDetailsViewController: MaterialShowcaseDelegate {
    func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
        sequence.showCaseWillDismis()
    }
}



