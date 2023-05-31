//
//  GalleryAndExhibitionViewController.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 30/06/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage


class GalleryAndExhibitionViewController: UIViewController {
    
    
    
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var galleryTableView: UITableView!
    
    var GalleryListModels =  GalleryListModel()
    var galleryorexhibition:String!
    
    @IBOutlet weak var notFoundLbl: UILabel!
    @IBOutlet weak var galleryExhibitionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        getGalleries(galleryorexhibition)
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func Back_Tapped(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
}

extension GalleryAndExhibitionViewController {
    
    func setupView() {
        
        TitleLbl.text = galleryorexhibition == GALLERIES ? LocalizationSystem.sharedInstance.localizedStringForKey(key: "gallery_details", comment: "") : LocalizationSystem.sharedInstance.localizedStringForKey(key: "exhibition_details",comment: "")
        
        let nib = UINib(nibName: "GalleryAndExhibitionTableViewCell", bundle: nil)
        self.galleryTableView.register(nib, forCellReuseIdentifier: "GalleryAndExhibitionTableViewCell")
        
    }
}

extension GalleryAndExhibitionViewController {
    
    func getGalleries(_ galleryorexhibition:String) {
        if Reachability.isConnectedToNetwork() {
             Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionAdd)
            WebServices.sharedInstance.getGalleries(galleryorexhibition,completionHandler: {
                (galleriesDetails:JSON,statusCode:Int) -> Void in
                 Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionRemove)
                if statusCode == 200 {
                     DispatchQueue.main.async {
                self.GalleryListModels.galleryListArray = GalleryLists.getGallerylistjson(galleryJSON: galleriesDetails["data"])
                self.galleryTableView.reloadData()
                    }
                }
            })
        }
        else {
            Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_internet", comment: ""), message: "")
        }
        
    }
}

extension GalleryAndExhibitionViewController : UITableViewDataSource, UITableViewDelegate,GalleryAndExhibitionTableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.GalleryListModels.galleryListArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:GalleryAndExhibitionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GalleryAndExhibitionTableViewCell") as! GalleryAndExhibitionTableViewCell
        cell.galleryorexhibition = galleryorexhibition
        cell.delegate = self
        cell.indexPath = indexPath
        cell.galleryImg!.sd_imageIndicator = SDWebImageActivityIndicator.large
        cell.galleryImg!.sd_imageIndicator = SDWebImageActivityIndicator.white
        cell.galleryImg!.sd_imageIndicator?.startAnimatingIndicator()
        cell.setupCell(gallery:GalleryListModels.galleryListArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat  {
        return 180
    }
    
    func selectedGalleryId(cell: GalleryAndExhibitionTableViewCell, indexPath: IndexPath) {
   
        if  galleryorexhibition == GALLERIES {
     NavigationController.NavigateToGalleryDetails(self,GalleryListModels.galleryListArray[indexPath.row]._id!,GALLERY_DETAILS)
        }
        else {
        NavigationController.NavigateToGalleryDetails(self,GalleryListModels.galleryListArray[indexPath.row]._id!,EXHIBITION_DETAILS)
        }
        
    }
}

