//
//  InstagramLoginVC.swift
//  InstagramLogin-Swift
//
//  Created by Aman Aggarwal on 2/7/17.
//  Copyright © 2017 ClickApps. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class InstagramLoginVC: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loginWebView: UIWebView!
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    var username,full_path,email,loginmedium,name:String!
    var social_id:Int!
    var register:RegisterDetails? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginWebView.delegate = self
        unSignedRequest()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - unSignedRequest
    func unSignedRequest () {
        let authURL = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True", arguments: [INSTAGRAM_IDS.INSTAGRAM_AUTHURL,INSTAGRAM_IDS.INSTAGRAM_CLIENT_ID,INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI, INSTAGRAM_IDS.INSTAGRAM_SCOPE ])
        let urlRequest =  URLRequest.init(url: URL.init(string: authURL)!)
        
        
        print(authURL)
        
        loginWebView.loadRequest(urlRequest)
    }
    
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        
        let requestURLString = (request.url?.absoluteString)! as String
        
        if requestURLString.hasPrefix(INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            handleAuth(authToken: requestURLString.substring(from: range.upperBound))
            return false;
        }
        return true
    }
    
    func handleAuth(authToken: String)  {
        Alamofire.request((String(format: "https://api.instagram.com/v1/users/self/?access_token=%@", authToken)),method: .get,encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
            switch response.result{
            case.success(let data):
                switch response.response?.statusCode {
                case 200:
                    var instadata:NSDictionary
                    instadata = data as! NSDictionary
                    instadata = instadata["data"] as! NSDictionary
                    var user = [String:Any]()
                    user[EMAIL] = instadata["username"]
                    self.username = instadata["username"] as? String
                    self.full_path = (instadata["profile_picture"] as! String)
                    self.social_id = instadata["id"] as? Int
                    self.loginmedium = "social"
                    user[LOGINMEDIUM] = "social"
                    
                    UserDefault.setLoginMode(INSTAMODE)
                    print(user)
                    
                    self.login(parameters: user)
                    break;
                default: break }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    // MARK: - UIWebViewDelegate
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        return checkRequestForCallbackURL(request: request)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        loginIndicator.isHidden = false
        loginIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loginIndicator.isHidden = true
        loginIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        webViewDidFinishLoad(webView)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension InstagramLoginVC {
    
    func login(parameters: [String:Any]) {
        
        if Reachability.isConnectedToNetwork() {
            
            WebServices.sharedInstance.loginUser(parameters, completionHandler: { (registerDetails:JSON,statusCode:Int) -> Void in
                
                if statusCode != 405 {
                    self.register = RegisterDetails.init(registersjson:registerDetails)
                    self.saveInDefaults(loggedInUser:self.register!)
                } else {
                    var paramDisc = [String:Any]()
                    var user = [String:Any]()
                    var usernameDisc = [String:Any]()
                    user[FULLPATH] = self.full_path
                    user[EMAILID] = self.username
                    user[LOGINMEDIUM] = self.loginmedium
                    user[IS_EMAIL_VALIDATED] = false
                    usernameDisc["fr"] = self.username
                    usernameDisc["en"] = self.username
                    user[USERNAME] = usernameDisc
                    user["social_id"] = self.social_id
                    paramDisc["user"] = user
                    paramDisc[IS_USER_FROM_APP] = true
                    self.registerUser(parameters: paramDisc)
                }
            })
        }
        else {
            Utility.ShowAlert(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: " no_internet", comment: ""), message: "")
        }
    }
    
    func saveInDefaults() {
        UserDefaults.standard.setValue(true, forKey: LOGINSTATUS)
        UserDefaults.standard.synchronize()
    }
    
}

extension InstagramLoginVC {
    
    func registerUser(parameters: [String:Any]) {
        if Reachability.isConnectedToNetwork() {
            WebServices.sharedInstance.registerUser(parameters, completionHandler: { (registerDetails:JSON,statusCode:Int) -> Void in
                self.register = RegisterDetails.init(registersjson:registerDetails)
                
                self.saveInDefaults(loggedInUser:self.register!)
            })
        }
        else {
          Utility.ShowAlert(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: " no_internet", comment: ""), message: "")
        }
    }
    
    func saveInDefaults(loggedInUser:RegisterDetails) {
        
        LocationManager.init()
       
        UserDefault.setUserId(loggedInUser._id)
        UserDefault.setLoginUserName(loggedInUser.name)
        UserDefault.setLoginUserName(loggedInUser.fullname)
        UserDefault.setLoginUserProfile(loggedInUser.full_path)
        UserDefault.setLoginUserEmail(loggedInUser.email)
        UserDefault.setLoginUserMONumber(loggedInUser.phone)
        
        print(loggedInUser.receive_notification)
        
        UserDefault.setReceiveNotification(loggedInUser.receive_notification)
        
        UserDefaults.standard.setValue(true, forKey: LOGINSTATUS)
        NavigationController.NavigateToBottomTabbarVC(self)
    }
    
}

