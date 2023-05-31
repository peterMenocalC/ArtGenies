//
//  MenuItemViewController.swift
//  Navigationdrawer
//
//  Created by Abhay Bachche on 24/09/18.
//  Copyright © 2018 Abhay Bachche. All rights reserved.
//

import UIKit
//import Firebase
//import FirebaseAuth
//import GoogleSignIn
//import FBSDKCoreKit
//import FBSDKLoginKit
import SDWebImage

class MenuItemViewController: UIViewController {
    
    var MenuViewModels =  MenuViewModel()
    var profileInfo:RegisterDetails!
    var myParam:String!
    var tapGesture = UITapGestureRecognizer()
    
    var navC = UIViewController.init()
    
    @IBOutlet var crossBtn: UIButton!
    
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var profileImgview: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var userphoneLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setupView()
        let rewel = self.revealViewController()
        rewel?.frontViewController.view.isUserInteractionEnabled = false
        rewel?.frontViewController.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let rewel = self.revealViewController()
        rewel?.frontViewController.view.isUserInteractionEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    
    @IBAction func CloseBtn_Tapped(_ sender: Any) {
        
        self.revealViewController().revealToggle(animated: true)
    }
}

extension MenuItemViewController {
    
    func setupView() {
        
        
        let img = UIImage.init(named: "clear-button.png")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.crossBtn.setImage(img, for: .normal)
        self.crossBtn.tintColor = .white
        
        Utility.setBorderAndCornerRadius(object:self.profileImgview.layer, width: 1.0, radius: 0 , color: UIColor.gray)

        tapGesture = UITapGestureRecognizer(target: self, action: #selector(MenuItemViewController.profileimageTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        profileImgview.addGestureRecognizer(tapGesture)
        profileImgview.isUserInteractionEnabled = true
        
        if let name = UserDefault.getLoginUserName() {
            self.usernameLbl.text = name
        }
        if let email = UserDefault.getLoginUserEmail() {
            self.userphoneLbl.text = email
        }
        //        else if let fullname = UserDefault.getLoginUserFullName() {
        //            self.usernameLbl.text = fullname
        //        }
        //
        
        self.profileImgview!.sd_imageIndicator = SDWebImageActivityIndicator.large
        self.profileImgview!.sd_imageIndicator = SDWebImageActivityIndicator.white
        self.profileImgview!.sd_imageIndicator?.startAnimatingIndicator()
        
        
        if let userimgurl =  UserDefault.getLoginUserProfile() {
            if userimgurl == "" {
            }
            else {
                
                   DispatchQueue.main.async {
                
            self.profileImgview.sd_setImage(with: URL(string: userimgurl), placeholderImage: UIImage(contentsOfFile: ""))
                }
            }
        }
        
        
        //        self.profileInfo = AppDelegate.sharedInstance.profileInfo
        //        if self.profileInfo != nil {
        //
        //            if let name = self.profileInfo.name {
        //                self.usernameLbl.text = name
        //            }
        //            if let email = self.profileInfo.email {
        //                self.userphoneLbl.text = email
        //            }
        //            if let userimgurl = self.profileInfo.full_path {
        //
        //                print(userimgurl)
        //
        //                self.profileImgview.sd_setImage(with: URL(string: userimgurl), placeholderImage: UIImage(contentsOfFile: ""))
        //            }
        //        }
        Utility.setBorderAndCornerRadius(object:self.profileImgview.layer, width: 0.3, radius: self.profileImgview.frame.size.height / 2, color: UIColor.gray)
        
        self.menuTableView.register( UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")
        languageCode = UserDefault.getCountryCode()
        
        self.menuTableView.contentInset = UIEdgeInsets(top:0, left: 0, bottom: 35, right: 0)
    }
    
    @objc func profileimageTapped(_ sender: UITapGestureRecognizer) {
        
        
        
    }
}


extension MenuItemViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuViewModels.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        cell.menuViewModels = MenuViewModels.menuArray[indexPath.row]
        return cell
    }
    
    func goEditProfileController() {
        
        //        let editView = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController
        //        navC = UINavigationController.init(rootViewController: editView!)
        //
        //        revealVC?.pushFrontViewController(navC, animated: true)
        //
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        languageCode = UserDefault.getCountryCode()
        let cell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        cell.setupCellForDidSelect(menuViewModels:MenuViewModels.menuArray[indexPath.row])
        var navC = UIViewController.init()
        let revealVC = self.revealViewController()
        
        //   let revealVC =
        
        // let revealVC = self.revealViewController()
        switch indexPath.row {
            
        case 0:
            
            
            
            let editView = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController
            
            tabBarController?.hidesBottomBarWhenPushed = false
            navC = UINavigationController.init(rootViewController: editView!)
            
            revealVC?.frontViewController = navC
            
            break
            
        case 1:
            
            let scannedView = self.storyboard?.instantiateViewController(withIdentifier: "ScannedArtsViewController") as? ScannedArtsViewController
            navC = UINavigationController.init(rootViewController: scannedView!)
            revealVC?.frontViewController = navC
            break
            
        case 2:
            
            let editView = self.storyboard?.instantiateViewController(withIdentifier: "StaticProfileViewController") as? StaticProfileViewController
            navC = UINavigationController.init(rootViewController: editView!)
            editView?.popview = "Language"
            revealVC?.frontViewController = navC
            
        case 3:
            
            let editView = self.storyboard?.instantiateViewController(withIdentifier: "StaticProfileViewController") as? StaticProfileViewController
            navC = UINavigationController.init(rootViewController: editView!)
            editView?.popview = "ReceiveNotification"
            revealVC?.frontViewController = navC
            
            
        case 4:
            
            let editView = self.storyboard?.instantiateViewController(withIdentifier: "TermandConditionViewController") as? TermandConditionViewController
            navC = UINavigationController.init(rootViewController: editView!)
            revealVC?.frontViewController = navC
            
        case 5:
        
            let editView = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as? PrivacyPolicyViewController
            navC = UINavigationController.init(rootViewController: editView!)
            revealVC?.frontViewController = navC
            
        case 6:
            
            let editView = self.storyboard?.instantiateViewController(withIdentifier: "ManagedPolicyViewController") as? ManagedPolicyViewController
            navC = UINavigationController.init(rootViewController: editView!)
            revealVC?.frontViewController = navC
            
        case 7:
            
            let editView = self.storyboard?.instantiateViewController(withIdentifier: "StaticProfileViewController") as? StaticProfileViewController
            navC = UINavigationController.init(rootViewController: editView!)
            editView?.popview = "Version"
            revealVC?.frontViewController = navC
            
            //  revealVC?.pushFrontViewController(navC, animated: true)
            break
            
            
            
        case 8:
            
            let nextView = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
            navC = UINavigationController.init(rootViewController: nextView!)
            logOut(vc: revealVC!,navC: navC)
            break
        default:
            break
        }
        
        self.revealViewController().revealToggle(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        cell.setupCellForDidDeSelect(menuViewModels:MenuViewModels.menuArray[indexPath.row])
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}

extension MenuItemViewController {
    func logOut(vc: SWRevealViewController, navC: UIViewController) {
        
        Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "logout_success", comment: ""), message: "")
        
        let cookieJar : HTTPCookieStorage = HTTPCookieStorage.shared
        for cookie in cookieJar.cookies! as [HTTPCookie]{
            print("cookie.domain = %@", cookie.domain)
            
            if cookie.domain == "www.instagram.com" ||
                cookie.domain == "api.instagram.com"{
                
                cookieJar.deleteCookie(cookie)
            }
        }
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
//
        self.removeSavedDefaults()
        self.tabBarController?.tabBar.isHidden = true
        tabBarController?.hidesBottomBarWhenPushed = true
        vc.pushFrontViewController(navC, animated: true)
    }
    
    func removeSavedDefaults() {
        runningdisplay = true
        UserDefault.clearUserId()
        UserDefault.clearLoginUserName()
        UserDefault.clearLoginUserEmail()
        UserDefault.clearLoginUserFullName()
        UserDefault.clearLoginUserProfile()
        UserDefault.clearLoginUserMONumber()
        UserDefaults.standard.removeObject(forKey: USERID)
        UserDefaults.standard.removeObject(forKey: LOGINSTATUS)
        
    }
}
