//
//  ScannedArtsViewController.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 30/06/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
import SDWebImage

class ScannedArtsViewController: UIViewController {
    
    @IBOutlet weak var notFoundLbl: UILabel!
    @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
    
    @IBOutlet var titleLblText: UILabel!
    @IBOutlet weak var scannedArtsCollectionView: UICollectionView!
    //var scannedArtsArray1:[Int] = [1,2,3,4,5]
    
    var scannedArtsArray = [Artists]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.setupView()
        getScannedArts()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    @IBAction func Back_Tapped(_ sender: Any) {
        
         NavigationController.NavigateToStaticProfile(self)
    }
    
    
    @IBAction func GallExhibiPreview_Tapped(_ sender: Any) {
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
}
extension ScannedArtsViewController {
    
    func setupView() {
//        if self.revealViewController() != nil {
//            menuBarButtonItem.target = self.revealViewController()
//            menuBarButtonItem.action = #selector(SWRevealViewController.revealToggle(_:))
//            revealViewController().rearViewRevealWidth = self.view.frame.width / 1.3
//        }
        self.titleLblText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "scanned_arts", comment: "")
        self.scannedArtsCollectionView.register(UINib(nibName: "ScannedArtsCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ScannedArtsCollectionViewCell")
    }
}


extension ScannedArtsViewController {
    
    func getScannedArts() {
        
        if Reachability.isConnectedToNetwork() {
            Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionAdd)
            
            WebServices.sharedInstance.getScanned(UserDefault.getUserId()!, completionHandler: { (artDetails:JSON,statusCode:Int) -> Void in
                
                 DispatchQueue.main.async {
                  Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionRemove)
                self.scannedArtsArray = Artdetails(artdetailsjson: artDetails[DATA],arts:SCANNED_ARTS).artists
                
                if self.scannedArtsArray.count == 0 {
                    self.notFoundLbl.isHidden = false
                    self.notFoundLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_scanned_art", comment: "")
                }
                self.scannedArtsCollectionView.reloadData()
                }
            })
        }
        else {
            Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_internet", comment: ""), message: "")
        }
        
    }
}

extension ScannedArtsViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scannedArtsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ScannedArtsCollectionViewCell = self.scannedArtsCollectionView.dequeueReusableCell(withReuseIdentifier: "ScannedArtsCollectionViewCell", for: indexPath) as! ScannedArtsCollectionViewCell
        cell.scannedArtsImg.sd_imageIndicator = SDWebImageActivityIndicator.large
        cell.scannedArtsImg.sd_imageIndicator = SDWebImageActivityIndicator.white
        cell.scannedArtsImg.sd_imageIndicator?.startAnimatingIndicator()
       // Utility.NVActivityStartAnimation(cell.scannedArtsImg)
        cell.setupCell(arts:self.scannedArtsArray[indexPath.row])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = self.scannedArtsCollectionView.bounds.width/2.0
        let yourHeight = yourWidth - 05
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        NavigationController.NavigateToArtInfo(self,scannedArtsArray[indexPath.row].id!,GALLERIES)
    }
    
}

