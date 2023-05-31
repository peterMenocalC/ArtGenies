//
//  GalleryExhibitionPreviewViewController.swift
//  ArtGenies
//
//  Created by Abhay Bachche on 07/09/19.
//  Copyright © 2019 Abhay Bachche. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class GalleryExhibitionPreviewViewController: UIViewController {

    @IBOutlet weak var previewCollectionView: UICollectionView!
    var sectionArray:[String] = [LocalizationSystem.sharedInstance.localizedStringForKey(key: "exhibition", comment: ""),LocalizationSystem.sharedInstance.localizedStringForKey(key: "", comment: ""),LocalizationSystem.sharedInstance.localizedStringForKey(key: "gallery", comment: "")]
    
    @IBOutlet var titleLblText: UILabel!
    var GalleryListArray = [GalleryLists]()
    var ExhibitioListArray = [ExhibitionsLists]()
    var GalleryFilterArray = [GalleryLists]()
    var ExhibitioFilterArray = [ExhibitionsLists]()
 
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        getGalleries()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func Map_Tapped(_ sender: Any) {
        
        NavigationController.NavigateToMap(self)
    }
}

extension GalleryExhibitionPreviewViewController {

    func setupView() {
        
         self.titleLblText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "galleryexhibitions", comment: "")
        
        self.previewCollectionView.register(UINib(nibName: "PreviewCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "PreviewCollectionViewCell")
        
         self.previewCollectionView.register(UINib(nibName: "LineCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "LineCollectionViewCell")
        
        self.previewCollectionView.register(UINib(nibName: "HeaderView", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        
//        sectionArray.append("Gallery")
//        sectionArray.append("")
        
//        cellsArray.append(arr1)
//        cellsArray.append(arr2)
        self.previewCollectionView.reloadData()
        
    }
}

extension GalleryExhibitionPreviewViewController {
    
    func getGalleries() {
        if Reachability.isConnectedToNetwork() {
            Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionAdd)
            WebServices.sharedInstance.getGalleriesExhibhitions(completionHandler: { (galleriesDetails:JSON,exhibitiondetails:JSON,statusCode:Int)  -> Void in
            Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionRemove)
                self.GalleryListArray = GalleryLists.getGallerylistjson(galleryJSON: galleriesDetails[DATA])
                self.GalleryFilterArray = Array(self.GalleryListArray.prefix(4))
                
                self.ExhibitioListArray = ExhibitionsLists.getExhibitionsListsjson(exhibitionsJSON: exhibitiondetails[DATA])
                
                 self.ExhibitioFilterArray = Array(self.ExhibitioListArray.prefix(4))
                self.previewCollectionView.reloadData()
                
            })
        }
        else {
            Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_internet", comment: ""), message: "")
        }
        
    }
}

extension GalleryExhibitionPreviewViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,HeaderViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return self.ExhibitioFilterArray.count
        }
        else if section == 1 {
            
            return 1
        }
        else {
              return self.GalleryFilterArray.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderView
            
            headerView.backgroundColor = UIColor.clear
            headerView.setupHeader(sectionname:sectionArray[indexPath.section],section:indexPath.section)
            headerView.indexPath = indexPath
            headerView.delegate = self
            return headerView
            
        default:
            break
        }
        
        return UIView() as! UICollectionReusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
       
        
        if indexPath.section == 0 {
            
             let cell:PreviewCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewCollectionViewCell", for: indexPath) as! PreviewCollectionViewCell
            
            cell.previewImg!.sd_imageIndicator = SDWebImageActivityIndicator.large
            cell.previewImg!.sd_imageIndicator = SDWebImageActivityIndicator.white
            cell.previewImg!.sd_imageIndicator?.startAnimatingIndicator()
            
            
//            Utility.NVActivityStartAnimation(cell.previewImg)

            cell.setupCellExhibition(exhibition:self.ExhibitioFilterArray[indexPath.row])
              return cell
        }
        else if indexPath.section == 1 {
            
             let cell:LineCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LineCollectionViewCell", for: indexPath) as! LineCollectionViewCell
            return cell
            
        }
        else if indexPath.section == 2 {
             let cell:PreviewCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewCollectionViewCell", for: indexPath) as! PreviewCollectionViewCell
            // Utility.NVActivityStartAnimation(cell.previewImg)
            
            cell.previewImg!.sd_imageIndicator = SDWebImageActivityIndicator.large
            cell.previewImg!.sd_imageIndicator = SDWebImageActivityIndicator.white
            cell.previewImg!.sd_imageIndicator?.startAnimatingIndicator()
            
             cell.setupCellGallery(gallery:self.GalleryFilterArray[indexPath.row])
              return cell
           
        }
        return UICollectionViewCell.init()
      
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
             NavigationController.NavigateToGalleryDetails(self,self.ExhibitioFilterArray [indexPath.row]._id!,EXHIBITION_DETAILS)
        }
        else if indexPath.section == 2 {
         NavigationController.NavigateToGalleryDetails(self,self.GalleryFilterArray [indexPath.row]._id!,GALLERY_DETAILS)
          
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat =  10
        
        if indexPath.section == 0 || indexPath.section == 2 {
            if UIDevice.current.screenType.rawValue == "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE" {
            
                let collectionViewSize = collectionView.frame.size.width - padding
                return CGSize(width: collectionViewSize/2, height: collectionViewSize/2 + 40 )
            
        } else {
       
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2 + 10 )
            }
        }
        else {
            
            return CGSize(width: view.frame.size.width, height: 10)
        }
        return CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
         if section == 0 || section == 2 {
            return CGSize(width: self.previewCollectionView.frame.size.width, height: 60)
        }
         else {
            return CGSize(width: self.previewCollectionView.frame.size.width, height: 40)
        }
    }
    
    func showMorPreview(view: HeaderView, indexPath: IndexPath) {
        if indexPath.section == 0 {
            NavigationController.NavigateToGalleryAndExhibition(self,EXHIBITIONS)
        }
        else if indexPath.section == 2 {
             NavigationController.NavigateToGalleryAndExhibition(self,GALLERIES)
   
        }
    }
}

