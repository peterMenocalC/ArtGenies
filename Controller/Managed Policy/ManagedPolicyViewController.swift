//
//  ManagedPolicyViewController.swift
//  ArtGenies
//
//  Created by Abhay Bachche on 22/09/19.
//  Copyright © 2019 Abhay Bachche. All rights reserved.
//

import UIKit
import SwiftyJSON

class ManagedPolicyViewController: UIViewController {

    @IBOutlet var backBtn: UIBarButtonItem!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var notFoundLbl: UILabel!
    
    var gallerywhitelist = [GalleryWhiteList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
       
        
        self.titleLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "managed_policy", comment: "")
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func BackBtn_Tapped(_ sender: Any) {
        
           NavigationController.NavigateToStaticProfile(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }
}

extension ManagedPolicyViewController {
    
    func setupView() {
        
        self.tableView.register(UINib(nibName: "ManagedPolicyTableViewCell", bundle: nil), forCellReuseIdentifier: "ManagedPolicyTableViewCell")
        getWhitelistGallery()
    }
}
extension ManagedPolicyViewController {
    
    func getWhitelistGallery() {
     
        if Reachability.isConnectedToNetwork() {
            
            Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionAdd)
            
            WebServices.sharedInstance.getWhitelistGallery(UserDefault.getUserId()!, completionHandler: { (galleryWhiteList:JSON,statusCode:Int) -> Void in
                DispatchQueue.main.async {
                    Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionRemove)
                    
                    
                    
                    self.gallerywhitelist =
                        GalleryDetails(galleryjson:galleryWhiteList[DATA]).whitelist
                    
                    print(self.gallerywhitelist.count)
                    
                    
                    if self.gallerywhitelist.count == 0 {
                    self.notFoundLbl.isHidden = true
                    self.notFoundLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "not_found_privacy", comment: "")
                    }
                    self.tableView.reloadData()
                }
            })
        }
        else {
             Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_internet", comment: ""), message: "")
        }
    }
    
    
    func ChangeStatus(parameters: [String:Any],galleryId:String) {
        
        if Reachability.isConnectedToNetwork() {
            
          //  Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionAdd)
            WebServices.sharedInstance.WhitelistGalleryChangeStatus(UserDefault.getUserId()!,galleryId,parameters, completionHandler: { (galleryWhiteList:JSON,statusCode:Int) -> Void in
                DispatchQueue.main.async {
                    
                  //  Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionRemove)
                    
                    self.gallerywhitelist = GalleryWhiteList.getwhitelistjson(whitelistJSON:galleryWhiteList[DATA][GALLERYWHITELIST])
                    
                    if self.gallerywhitelist.count == 0 {
                        
                    }
                    self.tableView.reloadData()
                }
            })
        }
        else {
            Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_internet", comment: ""), message: "")
        }
    }
}

extension ManagedPolicyViewController : UITableViewDataSource, UITableViewDelegate,SettingsSwitchProtocol {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.gallerywhitelist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ManagedPolicyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ManagedPolicyTableViewCell") as! ManagedPolicyTableViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        cell.setupCell(getWhitelistGallery: self.gallerywhitelist[indexPath.row])
        return cell
    }
    
    func settingsSwitchValueChanged(_ cell: ManagedPolicyTableViewCell, newValue: Bool,indexPath:IndexPath) {
        
        let Status:[String:Bool] = [STATUS:newValue]
        let galleryId = self.gallerywhitelist[indexPath.row].id
        
        self.ChangeStatus(parameters: Status,galleryId:galleryId!)
    }
}
