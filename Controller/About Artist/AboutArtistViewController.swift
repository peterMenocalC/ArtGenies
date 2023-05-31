//
//  AboutArtistViewController.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 07/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class AboutArtistViewController: UIViewController {

    @IBOutlet weak var aboutArtistTableView: UITableView!
    @IBOutlet var titleLblText: UILabel!
    
    @IBOutlet var notfoundLbl: UILabel!
    
    
     var aboutArtistArray:[Int] = [1,2]
     var CellToExpand = false
     var artistID:String!
     var artDetails:ArtistDetails? = nil
     var printsArtsArray = [UserOwnedDetails]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        getArtistInfo()
    }
    
    
    @IBAction func Back_Tapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Logout_Tapped(_ sender: Any) {
    }
}

extension AboutArtistViewController {
    
    func setupView() {
        
         self.titleLblText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "about_artist", comment: "")
        self.aboutArtistTableView.register(UINib(nibName: "ArtistInfotableViewCell", bundle: nil), forCellReuseIdentifier: "ArtistInfotableViewCell")
        self.aboutArtistTableView.register(UINib(nibName: "WorksArtistTableViewCell", bundle: nil), forCellReuseIdentifier: "WorksArtistTableViewCell")
        
    }
    func removeSavedDefaults() {
        
        UserDefaults.standard.removeObject(forKey: LOGINSTATUS)
    }
}

extension AboutArtistViewController {
    
    func getArtistInfo() {
        
        if Reachability.isConnectedToNetwork() {
             Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionAdd)
            WebServices.sharedInstance.getArtistInfo(artistID,completionHandler: {
                (artInfoDetails:JSON,printDetails,statusCode:Int) -> Void in
                 Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionRemove)
                
                if statusCode == 200 {
                     DispatchQueue.main.async {
                self.artDetails = ArtistDetails(artistdetailjson: artInfoDetails[DATA])
                self.printsArtsArray = UserOwnedDetails.getArtistsdetailjson(userownedJSON:printDetails[DATA],ID: UDID)
                self.aboutArtistTableView.reloadData()
                    }
                }
                else if statusCode == 404 {
                    self.notfoundLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_owned_art", comment: "")
                    
                }
                else if statusCode == 500 {
                     self.notfoundLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_owned_art", comment: "")
                }
                
            })
        }
        else {
            Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_internet", comment: ""), message: "")
        }
    }
}

extension AboutArtistViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.aboutArtistArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell:ArtistInfotableViewCell = tableView.dequeueReusableCell(withIdentifier: "ArtistInfotableViewCell") as! ArtistInfotableViewCell
            
            cell.artistImg!.sd_imageIndicator = SDWebImageActivityIndicator.large
            cell.artistImg!.sd_imageIndicator = SDWebImageActivityIndicator.white
            cell.artistImg!.sd_imageIndicator?.startAnimatingIndicator()

            if let artdetail = self.artDetails {
                cell.setupCell(artistdetail:artdetail)
            }
            cell.indexPath = indexPath
            cell.delegate = self
            // cell.setupCell()
            return cell
        }
        else {
            let cell:WorksArtistTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WorksArtistTableViewCell") as! WorksArtistTableViewCell
            cell.backgroundColor = Utility.hexStringToUIColor(hex: "0f0f0f")
            cell.setupCell1(artist:printsArtsArray)
            cell.backgroundColor = Utility.hexStringToUIColor(hex: "0f0f0f")
            cell.indexPath = indexPath
            cell.delegate1 = self
            cell.identifyVC = "AboutArtistVC"
            cell.identifyVCCell = "WorksArtist"
            return cell
        }
    }
}
extension AboutArtistViewController:ArtistInfotableViewCellDelegate,WorksArtistTableViewCellDelegate1 {
   
    func artsSelected(cell: WorksArtistTableViewCell, indexPath: IndexPath) {
    NavigationController.NavigateToArtInfo(self,printsArtsArray[indexPath.row].id!,GALLERIES)
    }
    
    func readMoreTapped(cell: ArtistInfotableViewCell, indexPath: IndexPath) {
        if CellToExpand == false {
            
            self.readmorelesscell(cell: cell,noOfLines: 0, cellToExpand: true, btnTitle:LocalizationSystem.sharedInstance.localizedStringForKey(key: "read_less", comment: ""))
        }
        else {
            
           self.readmorelesscell(cell: cell,noOfLines: 3, cellToExpand: false, btnTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "read_more", comment: ""))
            
        }
    }
    func readmorelesscell (cell:ArtistInfotableViewCell, noOfLines:Int,cellToExpand:Bool,btnTitle:String) {
        cell.artistDescLbl.numberOfLines = noOfLines
        cell.artistDescLbl.sizeToFit()
        self.aboutArtistTableView.reloadData()
        CellToExpand = cellToExpand
        cell.ReadmoreBtn.setTitle(btnTitle, for: .normal)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
    
        }
        else {
             return 230
        }
        return UITableView.automaticDimension
    }
}
