//
//  ArtInfoViewController.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 15/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit
import SwiftyJSON
import AVKit
import AVFoundation
import MaterialShowcase
import SDWebImage


class ArtInfoViewController: UIViewController {
    
    @IBOutlet var btnHeight: NSLayoutConstraint!
    
    
    @IBOutlet var artinfoLbl: UILabel!
    @IBOutlet var favouriteBtn: UIButton!
    @IBOutlet weak var topviewHeight: NSLayoutConstraint!
    @IBOutlet weak var artInfoTableView: UITableView!
    var oldContentOffset = CGPoint.zero
    var CellToExpand = false
    var artInfoArray:[Int] = [0,1,2,3,4]
    var artId:String!
    var cameraScan:Bool! = false
    var gallerygostatus:String!
    var ArtInfoDetail:ArtInfoDetails? = nil
    var ArtInfoDetailScanning:ArtInfoDetails?
    let viewModel = ViewModel()
    var identifyVCCell: String!
    @IBOutlet weak var scannedImg: UIImageView!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var statusViewHeightConstraint: NSLayoutConstraint!
    var sequence = MaterialShowcaseSequence()
    
    @IBOutlet weak var notfoundView: UIView!
    
    @IBOutlet weak var youtubeBtn: UIButton!
    @IBOutlet weak var downloadBtn: UIButton!
    
    @IBOutlet var ShareBtn: UIButton!
    
    @IBOutlet var notfoundLbl: UILabel!
    
    
    @IBOutlet weak var ExpertsBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        
        if  gallerygostatus ==  SCAN {
            var userDisc = [String:Any]()
            userDisc["user"] = [ID:UserDefault.getUserId()]
            getArtQRInfo(parameters: userDisc)
        }
        if cameraScan ==  true {
            self.ArtInfoDetail = ArtInfoDetailScanning
            self.artId = self.ArtInfoDetail?._id
            self.getFavoritesStatus()
            if let artimgurl =  self.ArtInfoDetail?.full_path {
                self.scannedImg.sd_setImage(with: URL(string: artimgurl), placeholderImage: UIImage(contentsOfFile: ""))
               

                self.backgroundImg.sd_setImage(with: URL(string: artimgurl), placeholderImage: UIImage(contentsOfFile: ""))
            }
            self.artInfoTableView.reloadData()
        }
        else {
            getArtInfo()
        }
        
        btnHeight.constant = 60
        topviewHeight.constant = 300
        backgroundImg.blurImage()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
       
    
        
        
        let showcase1 = MaterialShowcase()
        showcase1.setTargetView(view: ShareBtn)
        showcase1.primaryText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "share", comment: "")
        showcase1.secondaryText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "share_art_info", comment: "")
        showcase1.shouldSetTintColor = false // It should be set to false when button uses image.
        showcase1.backgroundPromptColor = Utility.hexStringToUIColor(hex: "#1493E5")
        showcase1.isTapRecognizerForTargetView = true
        showcase1.targetTintColor = UIColor.blue
        showcase1.targetHolderRadius = 44
        showcase1.targetHolderColor = UIColor.clear
        showcase1.primaryTextColor = UIColor.white
        showcase1.secondaryTextColor = UIColor.white
        showcase1.primaryTextSize = 30
        showcase1.secondaryTextSize = 20
        showcase1.delegate = self
        
//        let showcase2 = MaterialShowcase()
//        showcase2.setTargetView(view: youtubeBtn)
//        showcase2.primaryText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "video", comment: "")
//        showcase1.secondaryText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "see_video", comment: "")
//        showcase2.shouldSetTintColor = false // It should be set to false when button uses image.
//        showcase2.backgroundPromptColor = Utility.hexStringToUIColor(hex: "#1493E5")
//        showcase2.isTapRecognizerForTargetView = true
//        showcase2.targetHolderRadius = 44
//        showcase2.targetHolderColor = UIColor.clear
//        showcase2.primaryTextColor = UIColor.white
//        showcase2.secondaryTextColor = UIColor.white
//        showcase2.primaryTextSize = 30
//        showcase2.secondaryTextSize = 20
//        showcase2.delegate = self
//
        
        let showcase3 = MaterialShowcase()
        showcase3.setTargetView(view: downloadBtn)
        showcase3.primaryText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "download", comment: "")
        showcase1.secondaryText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "click_to_download", comment: "")
        showcase3.shouldSetTintColor = false // It should be set to false when button uses image.
        showcase3.backgroundPromptColor = Utility.hexStringToUIColor(hex: "#1493E5")
        showcase3.isTapRecognizerForTargetView = true
        showcase3.targetHolderRadius = 44
        showcase3.targetHolderColor = UIColor.clear
        showcase3.primaryTextColor = UIColor.white
        showcase3.secondaryTextColor = UIColor.white
        showcase3.primaryTextSize = 30
        showcase3.secondaryTextSize = 20
        showcase3.delegate = self
        
        
      //  sequence.temp(showcase1).temp(showcase2).temp(showcase3).setKey(key: "eve4").start()
        
        sequence.temp(showcase1).temp(showcase3).setKey(key: "eve4").start()
        
    }
   // }
    
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func ExpertsBtn_Tapped(_ sender: Any) {
        //  NavigationController.NavigateToExperts(self,self.ArtInfoDetail!.categories)
        
    }
    
    @IBAction func favouriteBtn_Tapped(_ sender: Any) {
        
        self.favoriteActivity()
        
        
        
    }
    
    func artShareCompletion() {
        
        let shareLink:String = sharebaseApiPath + "arts/details/?name=" + self.ArtInfoDetail!.name.replacingOccurrences(of: " ", with: "-") + "&art=" + self.artId
        
        let sharetext = shareLink
        let ac = UIActivityViewController(activityItems: [sharetext] as [Any], applicationActivities: nil)
        self.present(ac, animated: true)
        ac.completionWithItemsHandler = completionHandler
    }
    
    func completionHandler(activityType: UIActivity.ActivityType?, shared: Bool, items: [Any]?, error: Error?) {
        if (shared) {
            
            self.atrshare()
            
           
        }
        else {
        }
    }
    
    
    @IBAction func Share_Tapped(_ sender: Any) {
        
        self.artShareCompletion()
    }
    
    @IBAction func Videoplayer_Tapped(_ sender: Any) {
        
        
        if let videolink = self.ArtInfoDetail?.videolink {
//            NavigationController.NavigateToYoutubePlayer(self,"https://www.youtube.com/watch?v=2jzbakGCEOQ&list=RDMM2jzbakGCEOQ&start_radio=1")
        }
        else {
            Utility.ShowPopAlert(title: NSLocalizedString(LocalizationSystem.sharedInstance.localizedStringForKey(key: "video_unavaliable", comment: ""), comment: ""), message: "",timeinseconds: 2)
            
        }
        
        // https://www.youtube.com/watch?v=2jzbakGCEOQ&list=RDMM2jzbakGCEOQ&start_radio=1
        
        
        
        
        
        
        //            let videoURL = URL(string: "https://www.youtube.com/watch?v=2jzbakGCEOQ&list=RDMM2jzbakGCEOQ&start_radio=1")
        //            let player = AVPlayer(url: videoURL!)
        //            let playerViewController = AVPlayerViewController()
        //            playerViewController.player = player
        //            self.present(playerViewController, animated: true) {
        //                playerViewController.player!.play()
        //            }
        // }
    }
    
    
    @IBAction func Download_Tapped(_ sender: Any) {
        
        
        self.downloadshare()
        
//        var artDisc = [String:Any]()
//        artDisc[_ART] = [ID:self.artId!,NAME:self.ArtInfoDetail?.artnameObject as Any,THUMBPATH: self.ArtInfoDetail?.thumb_path as Any]
//        artDisc[GALLERY] = [ID:self.ArtInfoDetail?.gallery.id as Any,NAME:self.ArtInfoDetail?.gallery.gallerynameObject! as Any,THUMBPATH: self.ArtInfoDetail?.gallery.thumb_path! as Any]
//        artDisc[PURPOSE] = "download"
//        artDisc[USER] = [ID:UserDefault.getUserId()]
//        downloadBtn(parameters: artDisc)
    }
}
extension UIImageView{
    func blurImage()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    
    
}

extension ArtInfoViewController {
    
    func setupView() {
        
        
      
        
        self.artinfoLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "art_info", comment: "")
        self.artInfoTableView.register(UINib(nibName: "ArtInfoBasicTableViewCell", bundle: nil), forCellReuseIdentifier: "ArtInfoBasicTableViewCell")
        self.artInfoTableView.register(UINib(nibName: "DyanmicHyperlinkTableViewCell", bundle: nil), forCellReuseIdentifier: "DyanmicHyperlinkTableViewCell")
        self.artInfoTableView.register(UINib(nibName: "GalleryStatusTableViewCell", bundle: nil), forCellReuseIdentifier: "GalleryStatusTableViewCell")
        self.artInfoTableView.register(UINib(nibName: "OpenTodayTableViewCell", bundle: nil), forCellReuseIdentifier: "OpenTodayTableViewCell")
        self.artInfoTableView.register(UINib(nibName: "ExhibitionArtInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "ExhibitionArtInfoTableViewCell")
        
        favouriteBtn.backgroundColor = Utility.hexStringToUIColor(hex: "#1493E5")
        
        Utility.setBorderAndCornerRadius(object:self.favouriteBtn.layer, width: 0, radius: self.favouriteBtn.frame.size.height / 2, color: UIColor.clear)
        
        self.scannedImg!.sd_imageIndicator = SDWebImageActivityIndicator.large
        self.scannedImg!.sd_imageIndicator = SDWebImageActivityIndicator.white
        self.scannedImg!.sd_imageIndicator?.startAnimatingIndicator()
       
        
        // Utility.NVActivityStartAnimation(self.scannedImg!)
        
        
        //        WebServices.sharedInstance.findmatching(completionHandler: { (matching:JSON,statusCode:Int) -> Void in
        //
        //            print(matching)
        //
        //        })
        
    }
    
}


extension ArtInfoViewController {
    
    func getArtInfo() {
        if Reachability.isConnectedToNetwork() {
            Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionAdd)
            WebServices.sharedInstance.getArtInfo(self.artId,completionHandler: { (artInfoDetails:JSON,statusCode:Int) -> Void in
                Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionRemove)
                if statusCode == 200 {
                    DispatchQueue.main.async {
                        self.getFavoritesStatus()
                        self.ArtInfoDetail = ArtInfoDetails(artinfojson: artInfoDetails[DATA])
                        self.artId = self.ArtInfoDetail?._id
                        if let artimgurl =  self.ArtInfoDetail?.full_path {
                            self.scannedImg.sd_setImage(with: URL(string: artimgurl), placeholderImage: UIImage(contentsOfFile: ""))
                    

                            self.backgroundImg.sd_setImage(with: URL(string: artimgurl), placeholderImage: UIImage(contentsOfFile: ""))
                        }
                        self.artInfoTableView.reloadData()
                    }
                }
                else if statusCode == 404 {
                    
                  //  self.youtubeBtn.isHidden = true
                    self.downloadBtn.isHidden = true
                    //   self.ExpertsBtn.isHidden = true
                    self.ShareBtn.isHidden = true
                    self.notfoundView.isHidden = false
                    self.notfoundLbl.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "art_not_found", comment: "")
                    
                }
            })
        }
        else {
            Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_internet", comment: ""), message: "")
        }
    }
    
    func getArtQRInfo(parameters: [String:Any]) {
        
        
        if Reachability.isConnectedToNetwork() {
            
            Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionAdd)
            
            WebServices.sharedInstance.getArtQRInfo(self.artId,parameters,completionHandler: { (artInfoDetails:JSON,statusCode:Int) -> Void in
                
                Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionRemove)
                
                if statusCode == 200 {
                    self.getFavoritesStatus()
                    self.ArtInfoDetail = ArtInfoDetails(artinfojson: artInfoDetails[DATA])
                    self.artId = self.ArtInfoDetail?._id
                    if let artimgurl =  self.ArtInfoDetail?.full_path {
                        self.scannedImg.sd_setImage(with: URL(string: artimgurl), placeholderImage: UIImage(contentsOfFile: ""))
                       

                        self.backgroundImg.sd_setImage(with: URL(string: artimgurl), placeholderImage: UIImage(contentsOfFile: ""))
                    }
                    self.artInfoTableView.reloadData()
                }
                else if statusCode == 404 {
                    
                  //  self.youtubeBtn.isHidden = true
                    self.downloadBtn.isHidden = true
                    //  self.ExpertsBtn.isHidden = true
                    self.notfoundView.isHidden = false
                    self.notfoundLbl.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "art_not_found", comment: "")
                }
            })
        }
        else {
            Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_internet", comment: ""), message: "")
        }
    }
    
    
    func getFavoritesStatus() {
        
        if Reachability.isConnectedToNetwork() {
            WebServices.sharedInstance.getFavoritesStatus( self.artId,UserDefault.getUserId()!,completionHandler: { (favoritesstatusdetails:JSON,statusCode:Int) -> Void in
                
                if statusCode == 200 {
                    
                    
                    DispatchQueue.main.async {
                        
                        let cell = self.artInfoTableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! ArtInfoBasicTableViewCell
                        
                        let object = favoritesstatusdetails[DATA].dictionaryObject
                        let favoritearts:[Any] = object![FAVORITEARTS] as! [Any]
                        
                        if favoritearts.count > 0 {
                            
                            cell.favouriteBtn.setImage(UIImage(named: "likefill.png"), for: .normal)
                            self.favouriteBtn.setImage(UIImage(named: "likefill.png"), for:.normal)
                        }
                        else {
                            cell.favouriteBtn.setImage(UIImage(named: "likeempty.png"), for:.normal)
                            self.favouriteBtn.setImage(UIImage(named: "likeempty.png"), for:.normal)
                        }
                    }
                }
            })
        }
        else {
            Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_internet", comment: ""), message: "")
        }
    }
    
    
    
    func favoriteBtn(parameters: [String : Any]) {
        
        
        if Reachability.isConnectedToNetwork() {
            WebServices.sharedInstance.favoAndDownload(self.artId,parameters,completionHandler: { (favshareDownDetails:JSON,statusCode:Int) -> Void in
                
                if statusCode == 200 {
                    
                    
                    let cell = self.artInfoTableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! ArtInfoBasicTableViewCell
                    let object = favshareDownDetails[DATA].dictionaryObject
                    cell.favouriteLbl.text = String(object![FAVORITECOUNT] as! Int)
                    
                    if self.favouriteBtn.hasImage(named: "likefill.png", for: .normal) {
                        cell.favouriteBtn.setImage(UIImage(named: "likeempty.png"), for:.normal)
                        self.favouriteBtn.setImage(UIImage(named: "likeempty.png"), for:.normal)
                    } else {
                        cell.favouriteBtn.setImage(UIImage(named: "likefill.png"), for: .normal)
                        self.favouriteBtn.setImage(UIImage(named: "likefill.png"), for:.normal)
                    }
                }
            })
        }
        else {
            Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_internet", comment: ""), message: "")
        }
    }
    
    func sharedBtn(parameters: [String : Any]) {
        
        if Reachability.isConnectedToNetwork() {
            WebServices.sharedInstance.favoAndDownload( self.artId,parameters,completionHandler: { (favshareDownDetails:JSON,statusCode:Int) -> Void in
                
                if statusCode == 200 {
                    
                    let cell = self.artInfoTableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! ArtInfoBasicTableViewCell
                    let object = favshareDownDetails[DATA].dictionaryObject
                    
                    DispatchQueue.main.async {
                        cell.artShareLbl.text = String(object![SHARECOUNT] as! Int)
                        
                        
        Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "share_sucess", comment: ""), message: "")
                    }
                }
            })
        }
        else {
            Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_internet", comment: ""), message: "")
        }
    }
    
    
    func downloadBtn(parameters: [String : Any]) {
        
        if Reachability.isConnectedToNetwork() {
            WebServices.sharedInstance.favoAndDownload(artId,parameters,completionHandler: { (favshareDownDetails:JSON,statusCode:Int) -> Void in
                
                if statusCode == 200 {
                    
                    let cell = self.artInfoTableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! ArtInfoBasicTableViewCell
                    let object = favshareDownDetails[DATA].dictionaryObject
                    
                    DispatchQueue.main.async {
                        cell.downloadCountLbl.text = String(object![DOWNLOADCOUNT] as! Int)
                        self.viewModel.savePhoto(self.scannedImg.image) { (error) in
                            if let error = error {
                                print(error)
                            }
                        }
                       Utility.ShowAlert(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "download_successfully", comment: ""), message: "")
                    }
                }
            })
        }
        else {
            Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_internet", comment: ""), message: "")
        }
    }
}


extension ArtInfoViewController: UITableViewDataSource, UITableViewDelegate {
    
    //cells count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell:ArtInfoBasicTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ArtInfoBasicTableViewCell") as! ArtInfoBasicTableViewCell
            cell.indexPath = indexPath
            cell.delegate = self
            if let artdetail = self.ArtInfoDetail {
                cell.setupCell(artinfo:artdetail)
            }
            return cell
        case 1:
            let cell:DyanmicHyperlinkTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DyanmicHyperlinkTableViewCell") as! DyanmicHyperlinkTableViewCell
            if let artdetail = self.ArtInfoDetail {
                cell.setupCellArtInfo(artinfodetails:artdetail)
            }
            return cell
        case 2:
            let cell:GalleryStatusTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GalleryStatusTableViewCell") as! GalleryStatusTableViewCell
            if let artdetail = self.ArtInfoDetail?.gallery {
                cell.setupCell(artinfo:artdetail)
            }
            return cell
        case 3:
            let cell:OpenTodayTableViewCell = tableView.dequeueReusableCell(withIdentifier: "OpenTodayTableViewCell") as! OpenTodayTableViewCell
            cell.indexPath = indexPath
            cell.delegate = self
            // cell.galleryorexhibition = GALLERIES
            
            
            if let artdetail = self.ArtInfoDetail {
                cell.identifyVCCell = "OwnershipHTVCell"
                cell.identifyVC = "ArtInfoVC"
                cell.setupHeight()
                cell.setupCellOwner(artinfodetail:artdetail)
            }
            
            return cell
        case 4:
            let cell:ExhibitionArtInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ExhibitionArtInfoTableViewCell") as! ExhibitionArtInfoTableViewCell
            cell.indexPath = indexPath
            cell.delegate = self
            
            if let artdetail = self.ArtInfoDetail {
                cell.identifyVC = "ArtInfoVC"
                cell.identifyVCCell = "ExhibitionTableCell"
                cell.setupHeight()
                cell.setupCellExhibition(artinfodetail:artdetail)
            }
            return cell
            
        default:
            break
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 1:
            if self.ArtInfoDetail?.weblink == "" {
                return 8
            }
            else {
            return 75
            }
        case 2:
            return 80
        default:
            break
        }
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffset =  scrollView.contentOffset.y - oldContentOffset.y
        print("contentOffset,\(contentOffset)")
        print(" scrollView.contentOffse,\(scrollView.contentOffset.y)")
        
        if topviewHeight.constant > 0.0 && topviewHeight.constant != (-topviewHeight.constant){
            if contentOffset > 0 && scrollView.contentOffset.y > 0 {
                topviewHeight.constant = topviewHeight.constant -  scrollView.contentOffset.y
                btnHeight.constant = btnHeight.constant -  scrollView.contentOffset.y
                scrollView.contentOffset.y -= contentOffset
            }
        }
        print("hhhhh\(topviewHeight.constant)")
        if topviewHeight.constant < 300.0 && scrollView.contentOffset.y != (-scrollView.contentOffset.y)  {
            
            if topviewHeight.constant > 301.0 {
                topviewHeight.constant = 300
                btnHeight.constant = 60
            }
            else if contentOffset < 0 && scrollView.contentOffset.y < 0 {
                topviewHeight.constant = topviewHeight.constant - (scrollView.contentOffset.y)
                btnHeight.constant = 60
                //scrollView.contentOffset.y -= contentOffset
            }
        }
    }
}

extension ArtInfoViewController : ArtInfoBasicTableViewCellDelegate,OpenTodayTableViewCellDelegate,ExhibitionArtInfoTableViewCellDelegate{
    
    func downloadshare() {
       
        var artDisc = [String:Any]()
        artDisc[_ART] = [ID:self.artId!,NAME:self.ArtInfoDetail?.artnameObject as Any,THUMBPATH: self.ArtInfoDetail?.thumb_path as Any]
        artDisc[GALLERY] = [ID:self.ArtInfoDetail?.gallery.id as Any,NAME:self.ArtInfoDetail?.gallery.gallerynameObject! as Any,THUMBPATH: self.ArtInfoDetail?.gallery.thumb_path! as Any]
        artDisc[PURPOSE] = "download"
        artDisc[USER] = [ID:UserDefault.getUserId()]
        downloadBtn(parameters: artDisc)
    }
    func atrshare() {
    var artDisc = [String:Any]()
    artDisc[_ART] = [ID:self.artId!,NAME:self.ArtInfoDetail?.artnameObject as Any,THUMBPATH: self.ArtInfoDetail?.thumb_path as Any]
    artDisc[GALLERY] = [ID:self.ArtInfoDetail?.gallery.id as Any,NAME:self.ArtInfoDetail?.gallery.gallerynameObject! as Any,THUMBPATH: self.ArtInfoDetail?.gallery.thumb_path! as Any]
    artDisc[PURPOSE] = "share"
    artDisc[USER] = [ID:UserDefault.getUserId()]
    sharedBtn(parameters: artDisc)
        
    }
    func favoriteActivity() {
    var artDisc = [String:Any]()
    //        var artistName = [String:String]()
    // artistName[languageCode] = self.ArtInfoDetail?.name
    
    artDisc[_ART] = [ID:self.artId!,NAME:self.ArtInfoDetail?.artnameObject as Any,THUMBPATH: self.ArtInfoDetail?.thumb_path as Any]
    artDisc[GALLERY] = [ID:self.ArtInfoDetail?.gallery.id as Any,NAME:self.ArtInfoDetail?.gallery.gallerynameObject! as Any,THUMBPATH: self.ArtInfoDetail?.gallery.thumb_path! as Any]
    
    
    
    if favouriteBtn.hasImage(named: "likefill.png", for: .normal) {
    artDisc[PURPOSE] = "dislike"
    } else {
    artDisc[PURPOSE] = "favorite"
    }
    
    artDisc[USER] = [ID:UserDefault.getUserId()]
    favoriteBtn(parameters: artDisc)
    }
        
    func downloadTapped(cell: ArtInfoBasicTableViewCell, indexPath: IndexPath) {
        self.downloadshare()
        
    }
    
    func favoriteBtnTapped(cell: ArtInfoBasicTableViewCell, indexPath: IndexPath) {
        self.favoriteActivity()
        
    }
    
    func artShareTapped(cell: ArtInfoBasicTableViewCell, indexPath: IndexPath) {
      self.artShareCompletion()
    }
    
    func upAndDownArrow(cell: ExhibitionArtInfoTableViewCell, indexPath: IndexPath) {
        
        print("Bachcheclicked,\(indexPath.row)")
        
        if cell.CellToExpandOpenToday == false {
            cell.exbdaysTableView.isHidden = false
            cell.CellToExpandOpenToday = true
            cell.exbdaysTableView.reloadData()
            cell.height.constant = CGFloat(cell.ExhibitionArray.count * 60 + 05)
            self.artInfoTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            self.artInfoTableView.reloadData()
            let img1 = UIImage.init(named: "up-arrow")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            cell.exbmenuNameBtn.setImage(img1, for: .normal)
            cell.exbmenuNameBtn.tintColor = .darkGray
            cell.contentView.setNeedsUpdateConstraints()
        }
        else {
            let img1 = UIImage.init(named: "arrow-down")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            cell.exbmenuNameBtn.setImage(img1, for: .normal)
            cell.exbmenuNameBtn.tintColor = .darkGray
            cell.height.constant = 0
            cell.exbdaysTableView.isHidden = true
            cell.CellToExpandOpenToday = false
            self.artInfoTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            self.artInfoTableView.reloadData()
            cell.contentView.setNeedsUpdateConstraints()
            
        }
    }
    
    
    func upAndDownArrow(cell: OpenTodayTableViewCell, indexPath: IndexPath, identifyVC: String) {
        print("Abhayclicked,\(indexPath.row)")
        
        if cell.CellToExpandOpenToday == false {
            cell.daysTableView.isHidden = false
            cell.CellToExpandOpenToday = true
            cell.height.constant = CGFloat(cell.OwnerArray.count * 58 + 05)
            let img1 = UIImage.init(named: "up-arrow")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            cell.menuNameBtn.setImage(img1, for: .normal)
            cell.menuNameBtn.tintColor = .darkGray
            self.artInfoTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            self.artInfoTableView.reloadData()
            cell.contentView.setNeedsUpdateConstraints()
        }
        else {
            let img1 = UIImage.init(named: "arrow-down")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            cell.menuNameBtn.setImage(img1, for: .normal)
            cell.menuNameBtn.tintColor = .darkGray
            cell.height.constant = 0
            cell.daysTableView.isHidden = true
            cell.CellToExpandOpenToday = false
            self.artInfoTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            self.artInfoTableView.reloadData()
            cell.contentView.setNeedsUpdateConstraints()
            
        }
    }
    func goToArtDetail(cell: ArtInfoBasicTableViewCell, indexPath: IndexPath) {
        
        
        NavigationController.NavigateToAboutArtist(self,(self.ArtInfoDetail?.artist.id)!)
    }
    func readMoreTapped(cell: ArtInfoBasicTableViewCell, indexPath: IndexPath) {
        if CellToExpand == false {
            
            self.readmorelesscell(cell: cell,noOfLines: 0, cellToExpand: true, btnTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "read_less", comment: ""),viewDisplay:true,viewHeight: 55.0,indexPath:indexPath)
        }
        else {
            
            self.readmorelesscell(cell: cell,noOfLines: 5, cellToExpand: false, btnTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "read_more", comment: ""),viewDisplay:false,viewHeight: 0.0,indexPath:indexPath)
        }
    }
    func readmorelesscell (cell:ArtInfoBasicTableViewCell, noOfLines:Int,cellToExpand:Bool,btnTitle:String,viewDisplay:Bool,viewHeight:CGFloat,indexPath:IndexPath) {
        cell.artInfoDesc.numberOfLines = noOfLines
        cell.artInfoDesc.sizeToFit()
        CellToExpand = cellToExpand
        cell.ownerViewStatus = viewDisplay
        cell.ownerViewHeightConstraint.constant = viewHeight
        cell.readMoreBtn.setTitle(btnTitle, for: .normal)
        self.artInfoTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        self.artInfoTableView.reloadData()
    }
}

extension UIButton {
    func hasImage(named imageName: String, for state: UIControl.State) -> Bool {
        guard let buttonImage = image(for: state), let namedImage = UIImage(named: imageName) else {
            return false
        }
        
        return buttonImage.pngData() == namedImage.pngData()
    }
}


extension ArtInfoViewController: MaterialShowcaseDelegate {
    func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
        sequence.showCaseWillDismis()
    }
}
