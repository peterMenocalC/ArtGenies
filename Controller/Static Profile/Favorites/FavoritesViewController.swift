//
//  FavoritesViewController.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 05/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit
import SwiftyJSON
import XLPagerTabStrip
import SDWebImage

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    
    
    @IBOutlet weak var notFoundLbl: UILabel!
    var favoritesArtsArray = [Artists]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        getfavoriteArts()
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.setupView()
        getfavoriteArts()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FavoritesViewController {
    
    func getfavoriteArts() {
        
        if Reachability.isConnectedToNetwork() {
          //  Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionAdd)
            WebServices.sharedInstance.getfavorites(UserDefault.getUserId()!, completionHandler: { (artDetails:JSON,statusCode:Int) -> Void in
              //  Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionRemove)
                self.favoritesArtsArray = Artdetails(artdetailsjson: artDetails[DATA],arts:FAVORITE_ARTS).artists
                
                if self.favoritesArtsArray.count == 0 {
                 self.notFoundLbl.isHidden = false
                 self.notFoundLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_favorites_arts", comment: "")
                }
                self.favoritesCollectionView.reloadData()
            })
        }
        else {
            Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_internet", comment: ""), message: "")
        }
        
    }
}

extension FavoritesViewController : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:  LocalizationSystem.sharedInstance.localizedStringForKey(key: "favoritesTab", comment: ""), image: nil, highlightedImage: nil)
    }
}
extension FavoritesViewController {
    
    func setupView() {
        self.favoritesCollectionView.register(UINib(nibName: "ScannedArtsCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ScannedArtsCollectionViewCell")
        
    }
}
extension FavoritesViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesArtsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ScannedArtsCollectionViewCell = self.favoritesCollectionView.dequeueReusableCell(withReuseIdentifier: "ScannedArtsCollectionViewCell", for: indexPath) as! ScannedArtsCollectionViewCell
        cell.scannedArtsImg.sd_imageIndicator = SDWebImageActivityIndicator.large
        cell.scannedArtsImg.sd_imageIndicator = SDWebImageActivityIndicator.white
        cell.scannedArtsImg.sd_imageIndicator?.startAnimatingIndicator()
        cell.setupCell(arts:self.favoritesArtsArray[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = self.favoritesCollectionView.bounds.width/2.0
        let yourHeight = yourWidth - 05
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(self.favoritesArtsArray[indexPath.row].id!)
        
       NavigationController.NavigateToArtInfo(self,favoritesArtsArray[indexPath.row].id!,GALLERIES)
    }
    
}
