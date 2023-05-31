//
//  SearchArtViewController.swift
//  ArtGenies
//
//  Created by Abhay Bachche on 08/10/19.
//  Copyright © 2019 Abhay Bachche. All rights reserved.
//


import UIKit
import SwiftyJSON

class SearchArtViewController: UIViewController {
    
    @IBOutlet weak var notFoundLbl: UILabel!
    @IBOutlet var titleLblText: UILabel!
    @IBOutlet weak var artsCollectionView: UICollectionView!
    //var scannedArtsArray1:[Int] = [1,2,3,4,5]
    
    var ArtsArray = [Artists]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        getArts()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    @IBAction func Back_Tapped(_ sender: Any) {
        
          self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
}
extension SearchArtViewController {
    
    func setupView() {
        //        if self.revealViewController() != nil {
        //            menuBarButtonItem.target = self.revealViewController()
        //            menuBarButtonItem.action = #selector(SWRevealViewController.revealToggle(_:))
        //            revealViewController().rearViewRevealWidth = self.view.frame.width / 1.3
        //        }
        self.titleLblText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "arts", comment: "")
        self.artsCollectionView.register(UINib(nibName: "ScannedArtsCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ScannedArtsCollectionViewCell")
    }
}


extension SearchArtViewController {
    
    func getArts() {
        
        if Reachability.isConnectedToNetwork() {
            Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionAdd)
            
            WebServices.sharedInstance.getArts(completionHandler: { (artDetails:JSON,statusCode:Int) -> Void in
                
                DispatchQueue.main.async {
                    Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionRemove)
                    self.ArtsArray = Artists.getArtistsdetailjson(artistsJSON:artDetails[DATA],ID:UDID)
                    
                    if self.ArtsArray.count == 0 {
                        self.notFoundLbl.isHidden = false
                        self.notFoundLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "art_not_found", comment: "")
                    }
                    self.artsCollectionView.reloadData()
                }
            })
        }
        else {
            Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_internet", comment: ""), message: "")
        }
        
    }
}

extension SearchArtViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ArtsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ScannedArtsCollectionViewCell = self.artsCollectionView.dequeueReusableCell(withReuseIdentifier: "ScannedArtsCollectionViewCell", for: indexPath) as! ScannedArtsCollectionViewCell
        cell.setupCell(arts:self.ArtsArray[indexPath.row])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = self.artsCollectionView.bounds.width/2.0
        let yourHeight = yourWidth - 05
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        NavigationController.NavigateToArtInfo(self,ArtsArray[indexPath.row].id!,GALLERIES)
    }
    
}

