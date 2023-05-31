//
//  OwnedViewController.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 05/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit
import SwiftyJSON
import XLPagerTabStrip
import SDWebImage

class OwnedViewController: UIViewController {
    
    @IBOutlet weak var ownedArtsCollectionView: UICollectionView!
    
    @IBOutlet weak var notFoundLbl: UILabel!
    
    var ownedArtsArray = [Artists]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
       // getownedArts()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setupView()
        getownedArts()
    }
}
extension OwnedViewController : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "owned", comment: ""), image: nil, highlightedImage: nil)
    }
}
extension OwnedViewController {
    
    func setupView() {
        self.ownedArtsCollectionView.register(UINib(nibName: "ScannedArtsCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ScannedArtsCollectionViewCell")
    }
}

extension OwnedViewController {
    
    func getownedArts() {
        
        if Reachability.isConnectedToNetwork() {
          //  Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionAdd)
            WebServices.sharedInstance.getowned(UserDefault.getUserId()!, completionHandler: { (artDetails:JSON,statusCode:Int) -> Void in
              //   Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionRemove)
                self.ownedArtsArray = Artdetails(artdetailsjson: artDetails[DATA],arts:OWNEDARTS).artists
                if self.ownedArtsArray.count == 0 {
                    self.notFoundLbl.isHidden = false
                    self.notFoundLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_owned_art", comment: "")
                }
                self.ownedArtsCollectionView.reloadData()
            })
        }
        else {
            Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_internet", comment: ""), message: "")
        }
        
    }
}

extension OwnedViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ownedArtsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ScannedArtsCollectionViewCell = self.ownedArtsCollectionView.dequeueReusableCell(withReuseIdentifier: "ScannedArtsCollectionViewCell", for: indexPath) as! ScannedArtsCollectionViewCell
        cell.scannedArtsImg.sd_imageIndicator = SDWebImageActivityIndicator.large
        cell.scannedArtsImg.sd_imageIndicator = SDWebImageActivityIndicator.white
        cell.scannedArtsImg.sd_imageIndicator?.startAnimatingIndicator()
        cell.setupCell(arts:self.ownedArtsArray[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = self.ownedArtsCollectionView.bounds.width/2.0
        let yourHeight = yourWidth - 05
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        NavigationController.NavigateToArtInfo(self,ownedArtsArray[indexPath.row]._id!,GALLERIES)
    }
}


