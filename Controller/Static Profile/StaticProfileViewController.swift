//
//  StaticProfileViewController.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 05/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SDWebImage

class StaticProfileViewController: ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var profileName: UILabel!
    var profileInfo:RegisterDetails!
    @IBOutlet weak var navProfile: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
    var popview:String!
    override func viewDidLoad() {
        
        
        self.loadDesignButtonBar()
        self.setupView()
        if self.revealViewController() != nil {
            menuBarButtonItem.target = self.revealViewController()
            menuBarButtonItem.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = self.view.frame.width / 1.3
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        languageCode = UserDefault.getCountryCode()
        self.navigationController?.isNavigationBarHidden = true
        if popview == "Language" {
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LanguageChangeViewController") as! LanguageChangeViewController
            self.addChild(popOverVC)
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParent: self)
        }
       else if popview == "ReceiveNotification" {
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReceiveNotificationsController") as! ReceiveNotificationsController
            self.addChild(popOverVC)
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParent: self)
            
        }
        else if popview == "Version" {
            
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                
                if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                    
                    Utility.ShowPopAlert(title: "version " + version  , message: "",timeinseconds: 2)
                    
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        popview = ""

//        if popview == "Language" {
//             let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LanguageChangeViewController") as! LanguageChangeViewController
//
//            self.removeFromParent()
//            self.view.removeFromSuperview()
//        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //    override func viewDidDisappear(_ animated: Bool) {
    //        if self.revealViewController() != nil {
    //            menuBarButtonItem.target = self.revealViewController()
    //            menuBarButtonItem.action = #selector(SWRevealViewController.revealToggle(_:))
    //            revealViewController().rearViewRevealWidth = self.view.frame.width / 1.3
    //            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    //        }
    //    }
    
    @IBAction func Back_Tapped(_ sender: Any) {
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return self.tabsForBar()
    }
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        if indexWasChanged && toIndex > -1 && toIndex < viewControllers.count {
        }
    }
}

extension StaticProfileViewController: SWRevealViewControllerDelegate {
    
    
    func setupView() {
        Utility.setBorderAndCornerRadius(object:self.navProfile.layer, width: 0.3, radius: self.navProfile.frame.size.height / 2, color: UIColor.gray)
        //        let tabbar = tabBarController as! BottomTabbarViewController
        //        self.profileInfo = tabbar.profileInfo
        
        
        if let name = UserDefault.getLoginUserName() {
            self.profileName.text = name
        }
        
        
        

        
        if let userimgurl =  UserDefault.getLoginUserProfile() {
            
            if userimgurl == "" {
            }
            else {
                
                   DispatchQueue.main.async {
                
               self.navProfile.sd_setImage(with: URL(string: userimgurl), placeholderImage: UIImage(contentsOfFile: ""))
                }
            }
        }
        
        
        //        self.profileInfo = AppDelegate.sharedInstance.profileInfo
        //        if self.profileInfo != nil {
        //
        //            if let name = self.profileInfo.name {
        //                self.profileName.text = name
        //            }
        //
        //            if let userimgurl = self.profileInfo.full_path {
        //
        //                self.navProfile.sd_setImage(with: URL(string: userimgurl), placeholderImage: UIImage(contentsOfFile: ""))
        //            }
        //        }
    }
}

extension StaticProfileViewController {
    
    func loadDesignButtonBar() {
        
        // settings.style.buttonBarBackgroundColor = .yellow
        settings.style.buttonBarItemBackgroundColor = Utility.hexStringToUIColor(hex: "#2D2D2D")
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 16)
        settings.style.buttonBarMinimumInteritemSpacing = 0
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .red
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.selectedBarBackgroundColor = .white
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .lightGray
            newCell?.label.textColor = .white
        }
    }
    
    func tabsForBar() -> [UIViewController] {
        
        let visitsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavoritesViewController")
        
        
        let infoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OwnedViewController")
        
        
        
        return [visitsVC,infoVC]
    }
}
