//
//  SearchViewController.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 05/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit
import SwiftyJSON
import Material
import MaterialShowcase


class SearchViewController: UIViewController {
    
    @IBOutlet var searchTF: UITextField!
    var searchSectionArray:[Int] = [0,1,2]
    var SearchDetail:SearchDetails? = nil
    
    @IBOutlet var searchBtn: UIButton!
    
    @IBOutlet weak var searchView: SearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    var sequence = MaterialShowcaseSequence()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        self.searchTF.attributedPlaceholder = NSAttributedString(string: LocalizationSystem.sharedInstance.localizedStringForKey(key: "enter_here_to_search", comment: ""), attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
    //    self.searchTF.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "enter_here_to_search", comment: "")
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
//
        
        let showcase1 = MaterialShowcase()
        showcase1.setTargetView(view: searchBtn)
        showcase1.primaryText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "search", comment: "")
        showcase1.secondaryText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "enter_to_find", comment: "")
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
        sequence.temp(showcase1).setKey(key: "eve").start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getSearchInfo()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        searchTF.text = "" }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        self.changeBottomTabbarIcons()
//    }
    
    
    
    
    @IBAction func SearchBtn_Tapped(_ sender: Any) {
        
//        if !searchTF.text!.isEmpty {
             self.search()
      //  }
    }
   
}
extension SearchViewController {
    
    func search() {
        
        var searchDict = [String:Any]()
        searchDict[TERM] = self.searchTF.text
        self.view.endEditing(true)
        
        searchInfoKeyword(parameters: searchDict)
    }
    func searchForBackspace() {
        
        var searchDict = [String:Any]()
        searchDict[TERM] = self.searchTF.text
        searchInfoKeyword(parameters: searchDict)
    }
    
    func changeBottomTabbarIcons() {
//        if let downcastImage = self.tabBarController?.tabBar.items {
//            downcastImage[2].selectedImage = UIImage.init(named: "likeempty.png")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//            downcastImage[2].ti
//        }
    }
    
    func setupView() {
        
        languageCode = UserDefault.getCountryCode()
        searchTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: searchTF.frame.height))
        searchTF.leftViewMode = .always
        searchTF.attributedPlaceholder = NSAttributedString(string: "Enter here to search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        let image = UIImage(named: "search.png")
        searchBtn.setImage(image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        searchBtn.tintColor = UIColor.white
        
        Utility.setBorderAndCornerRadius(object:self.searchView.layer, width: 2, radius:0,color: UIColor.gray)
        let searchTablenib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        self.searchTableView.register(searchTablenib, forCellReuseIdentifier: "SearchTableViewCell")
        let bannernib = UINib(nibName: "BannerTableViewCell", bundle: nil)
        self.searchTableView.register(bannernib, forCellReuseIdentifier: "BannerTableViewCell")
        
    }
}


extension SearchViewController {
    
    func getSearchInfo() {
        
        if Reachability.isConnectedToNetwork() {
            Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionAdd)
            WebServices.sharedInstance.getSearchInfo(completionHandler: { (searchDetails:JSON,statusCode:Int) -> Void in
                
                 Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionRemove)
                
                if statusCode == 200 {
                    self.SearchDetail = SearchDetails.init(searchjson: searchDetails[DATA])
                    
                    self.searchTableView.reloadData()
                    
                }
                else if statusCode == 404 {
                    
                }
            })
        }
        else {
           Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_internet", comment: ""), message: "")
        }
    }
    
    func searchInfoKeyword(parameters: [String:Any]) {
        
        if Reachability.isConnectedToNetwork() {
             Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionAdd)
            WebServices.sharedInstance.searchInfoKeyword(parameters, completionHandler: {
                (searchDetails:JSON,statusCode:Int) -> Void in
                 Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionRemove)
                if statusCode == 200 {
                    self.SearchDetail = SearchDetails.init(searchjson: searchDetails[DATA])
                    //self.searchTF.text = ""
                   DispatchQueue.main.async {
                  //  self.searchSectionArray.removeAll()
//                    if (self.SearchDetail?.exhibitions.count)! > 0 {
//                        self.searchSectionArray.append(1)
//                    } else if (self.SearchDetail?.galleries.count)! > 0 {
//                        self.searchSectionArray.append(1) }
//                    else if (self.SearchDetail?.arts.count)! > 0 {
//                        self.searchSectionArray.append(1) }
                    self.searchTableView.reloadData()
                    self.searchTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                    }
                    
                    }
                else if statusCode == 404 {
                    
                }
            })
        }
        else {
             Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_internet", comment: ""), message: "")
        }
    }
    
}
extension SearchViewController : UITableViewDataSource, UITableViewDelegate, SearchTableViewCellDelegate{
    func keyboardHide(cell: SearchTableViewCell) {
        searchTF.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    
    func showMoreBtnTapped(cell: SearchTableViewCell, indexPath: IndexPath, identifyVCCell: String) {
      
         self.changeBottomTabbarIcons()
      
        if  identifyVCCell == "GalleryCollectionCell" {
               NavigationController.NavigateToGalleryAndExhibition(self,GALLERIES)
        }
        else if identifyVCCell == "ExhibitionTableCell" {
            
             NavigationController.NavigateToGalleryAndExhibition(self,EXHIBITIONS)
        }
        else {
            NavigationController.NavigateToSearchArt(self)
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.searchSectionArray.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
         let cell:SearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as! SearchTableViewCell
        
        cell.indexPath = indexPath
        cell.delegate = self
        
        if let searchdetail = self.SearchDetail {
        
            if indexPath.section == 0 { cell.setupCell(index:self.searchSectionArray[indexPath.row],searchdetail:searchdetail,identifyVCCell:"ExhibitionTableCell")
        }
            else if indexPath.section == 1 { cell.setupCell(index:self.searchSectionArray[indexPath.row],searchdetail:searchdetail,identifyVCCell:"GalleryCollectionCell")
                
        }
            else if indexPath.section == 2 { cell.setupCell(index:self.searchSectionArray[indexPath.row],searchdetail:searchdetail,identifyVCCell:"ArtCollectionViewCell")
                
        }
//            else if indexPath.section == 1 {
//                let cell:BannerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell") as! BannerTableViewCell
//                return cell
//            }
    }
        
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 && self.SearchDetail?.exhibitions.count == 0 {
            return 0
        }
        else if indexPath.section == 1 && self.SearchDetail?.galleries.count == 0 {
            return 0
        }   else if indexPath.section == 2 && self.SearchDetail?.arts.count == 0 {
            
            return 0
        }
        else {
            return 260
        }
        
//        if indexPath.section == 1
//        {
//             return 180
//        }
//        else if indexPath.section == 0 && self.SearchDetail?.exhibitions.count == 0 {
//            return 0
//        }
//        else if indexPath.section == 2 && self.SearchDetail?.galleries.count == 0 {
//            return 0
//        }   else if indexPath.section == 3 && self.SearchDetail?.arts.count == 0 {
//
//            return 0
//        }
//        else {
//             return 260
//        }
       
    }
    
    func searchResultTapped(cell: SearchTableViewCell, indexPath: IndexPath, identifyVCCell: String) {
        
        self.changeBottomTabbarIcons()
        self.view.endEditing(true)
        
        if  identifyVCCell == "GalleryCollectionCell" {
            
        NavigationController.NavigateToGalleryDetails(self,(self.SearchDetail?.galleries[indexPath.row]._id!)!,GALLERY_DETAILS)
            
        }
        else if identifyVCCell == "ExhibitionTableCell" {
       
           
        NavigationController.NavigateToGalleryDetails(self,(self.SearchDetail?.exhibitions[indexPath.row]._id!)!,EXHIBITION_DETAILS)
        }
        else {
        NavigationController.NavigateToArtInfo(self,(self.SearchDetail?.arts[indexPath.row].id!)!,GALLERY_DETAILS)
        }
    }
        
}

extension SearchViewController : UITextFieldDelegate{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isBackspace {
            if self.searchTF.text!.count == 1 {
                searchTF.text = ""
                self.searchForBackspace()
                return true
            }
        }
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        if textField == self.searchTF {
            
            //if self.searchTF!.text != "" {
                 self.search()
           // }
        }
        return true
    }
}

extension SearchViewController: MaterialShowcaseDelegate {
    func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
        sequence.showCaseWillDismis()
    }
}


extension String {
    var isBackspace: Bool {
        let char = self.cString(using: String.Encoding.utf8)!
        return strcmp(char, "\\b") == -92
    }
}
