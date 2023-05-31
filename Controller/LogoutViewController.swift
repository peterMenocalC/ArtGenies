//
//  LogoutViewController.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 19/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit
//import Firebase
//import FirebaseAuth
//import GoogleSignIn
//import FBSDKCoreKit
//import FBSDKLoginKit

class LogoutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func removeSavedDefaults() {
        
        UserDefaults.standard.removeObject(forKey: LOGINSTATUS)
        UserDefault.clearUserId()
    }

    @IBAction func Logout_Tapped(_ sender: Any) {
        
        self.removeSavedDefaults()
        
        let mode = UserDefault.getLoginMode()
//        switch mode {
//        case CUSTOMMODE:
//            break
//        case GOOGLEMODE:
//            break
//        case FBMODE:
//            let firebaseAuth = Auth.auth()
//            do {
//                try firebaseAuth.signOut()
//            } catch let signOutError as NSError {
//                print ("Error signing out: %@", signOutError)
//            }
//            break
//        case INSTAMODE:
//            let cookieJar : HTTPCookieStorage = HTTPCookieStorage.shared
//            for cookie in cookieJar.cookies! as [HTTPCookie]{
//                print("cookie.domain = %@", cookie.domain)
//
//                if cookie.domain == "www.instagram.com" ||
//                    cookie.domain == "api.instagram.com"{
//
//                    cookieJar.deleteCookie(cookie)
//                }
//            }
//            break
//        default: break
//        }
        NavigationController.NavigateToLogin(self)
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
