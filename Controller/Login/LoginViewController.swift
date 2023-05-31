//
//  LoginViewController.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 23/06/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit
import Material
//import Firebase
//import FirebaseAuth
//import GoogleSignIn
//import FBSDKCoreKit
//import FBSDKLoginKit
import SwiftyJSON
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var backgroundgif: UIImageView!
    @IBOutlet weak var logoImg: UIImageView!
//    @IBOutlet weak var googleSignIn: GIDSignInButton!
    @IBOutlet weak var emailIdTF: TextField!
    @IBOutlet weak var passwordTF: TextField!
//    @IBOutlet weak var facebookBtn: UIButton!
//    @IBOutlet weak var instaBtn: UIButton!
    @IBOutlet weak var emailIdHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var registerBtnBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var erroremailLbl: UILabel!
    @IBOutlet weak var errorPasswordLbl: UILabel!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet var forgotPasswordBtn: UIButton!
    @IBOutlet var dontAccountLbl: UILabel!
//    @IBOutlet var nowLbl: UILabel!
    @IBOutlet var signupBtn: UIButton!
    @IBOutlet var orLbl: UILabel!
    var fullname,mobilenumber,profilepic,email,loginmedium:String!
    var register:RegisterDetails? = nil
    let kBottomViewPadding: CGFloat = 140
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.emailIdTF.text = "pranit+1@gmail.com"
//        self.passwordTF.text = "Pranit@123"

//        self.emailIdTF.text = "abhaysing0811@gmail.com"
//        self.passwordTF.text = "Abhay@9890"
        
//        self.emailIdTF.text = "testercodaemon@yopmail.com"
//        self.passwordTF.text = "Sumit@123"
        
        
//        self.emailIdTF.text = "shrikantjadhav86@gmail.com"
//        self.passwordTF.text = "Test@1234"
        
        
//        self.emailIdTF.text = "pranitjadhavcodaemon@yopmail.com"
//        self.passwordTF.text = "Test@1234"
//
        
        //
        self.setupView()
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self);
    }
//    @IBAction func GoogleSignBtn_Tapped(_ sender: Any) {
////        GIDSignIn.sharedInstance().uiDelegate = self
////        GIDSignIn.sharedInstance().signIn()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
//    @IBAction func fb_Tapped(_ sender: Any) {
//        let loginManager = LoginManager()
//        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
//            if let error = error {
//                print("Failed to login: \(error.localizedDescription)")
//                return}
//            guard let accessToken = AccessToken.current else {
//                print("Failed to get access token")
//                return
//            }
//            if result!.isCancelled {
//
//            }
//            else {
//                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
//                Auth.auth().signIn(with: credential) { (authResult, error) in
//                    if let error = error {
//                        // ...
//                        return
//                    }
//                    else {
//
//                        print(error?.localizedDescription)
//
//                        var paramDisc = [String:Any]()
//                        var user = [String:Any]()
//                        user[EMAILID] = String((Auth.auth().currentUser?.email)!)
//                        self.email = String((Auth.auth().currentUser?.email)!)
//                        self.profilepic = (Auth.auth().currentUser?.photoURL!.absoluteString)!
//                        self.fullname = String((Auth.auth().currentUser?.displayName)!)
//
//                        self.loginmedium = "social"
//                        user[LOGINMEDIUM] = "social"
//
//                        UserDefault.setLoginMode(FBMODE)
//                        self.login(parameters: user)
//                    }
//                }
//            }
//        }
//
//
//        print("Found")
//    }
    
    
    @IBAction func ForgotPassword_Tapped(_ sender: Any) {
        
        NavigationController.NavigateToForgotPassword(self)
        
    }
    
    @IBAction func Signin_Tapped(_ sender: Any) {
        
        
        if (self.passwordTF.text?.isEmpty)! || (!Utility.isPasswordValid(self.passwordTF.text!)) {
            self.passwordHeightConstraint.constant = 20
            self.errorPasswordLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "password_required", comment: "")
        }
        if (self.emailIdTF.text?.isEmpty)! || (!Utility.isValidEmail(self.emailIdTF.text!))  {
            self.emailIdHeightConstraint.constant = 20
            self.erroremailLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "email_required", comment: "")
            
        }
        if (Utility.isPasswordValid(self.passwordTF.text!)) &&  (Utility.isValidEmail(self.emailIdTF.text!)) {
            
            
            self.view.endEditing(true)
            var paramDisc = [String:Any]()
            paramDisc[EMAILID] = emailIdTF.text
            paramDisc[PASSWORD] = passwordTF.text
            UserDefault.setLoginMode(CUSTOMMODE)
            login(parameters: paramDisc)
        }
    }
    
//    @IBAction func InstaBtn_Tapped(_ sender: Any) {
//        NavigationController.navigateToInstagramLoginVC(self)
//    }
    
    @IBAction func Register_Tapped(_ sender: Any) {
        NavigationController.navigateToRegister(self)
        self.hideErrorLabels()
    }
    
    
}
extension LoginViewController {
    
    func setupView() {
        
        
        do {
            let gif = try UIImage(gifName: "background_video.gif")
            self.backgroundgif.setGifImage(gif)
        } catch {
            print(error)
        }
        
        languageCode = UserDefault.getCountryCode()
        
        self.emailIdTF.placeholderLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "email_id", comment: "")
        self.passwordTF.placeholderLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "password", comment: "")
        self.signInBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sign_in", comment: ""), for: .normal)
        self.signupBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sign_up", comment: ""), for: .normal)
        self.forgotPasswordBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "forgot_password", comment: ""), for: .normal)
        self.orLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "or", comment: "")
        self.dontAccountLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "not_account", comment: "")
        
        
        
        
        
        emailIdTF.textColor = .white
        passwordTF.textColor = .white
        self.hideErrorLabels()
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        self.registerBtnBottomConstraint.constant =  appDelegate.window!.frame.size.height <= 800.0 ? kBottomViewPadding : kBottomViewPadding * 1.7
        
      
        
    }
    func hideErrorLabels() {
        self.emailIdHeightConstraint.constant = 0
        self.passwordHeightConstraint.constant = 0
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension LoginViewController {
    
    func login(parameters: [String:Any]) {
        self.hideErrorLabels()
        
        if Reachability.isConnectedToNetwork() {
            
            Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionAdd)
            
            WebServices.sharedInstance.loginUser(parameters, completionHandler: { (registerDetails:JSON,statusCode:Int) -> Void in
                
                
                Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionRemove)
                
                DispatchQueue.main.async {
                
                    
                    if statusCode == 402 {
                        Utility.ShowAlert(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "login_validate_email", comment: ""), message: "")

                    }
                    else if statusCode == 404 {
                        
                    Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "invalid_email_password", comment: ""), message: "")
                        
                    }
                   else if statusCode == 200 {
                        
                        self.register = RegisterDetails.init(registersjson:registerDetails[DATA])
                        UserDefaults.standard.setValue(self.register!._id, forKey: USERID)
                        self.saveInDefaults(loggedInUser: self.register!)
                    }
//                    else {
//                        var paramDisc = [String:Any]()
//                        var user = [String:Any]()
//                        user[EMAILID] =  self.email
//                        //  user[MOBILENUMBER] =  self.mobilenumber
//                        user[LOGINMEDIUM] = self.loginmedium
//                        user[PROFILEPICTURE] = self.profilepic
//                        user[IS_EMAIL_VALIDATED] = false
//                        paramDisc["user"] = user
//                        paramDisc[IS_USER_FROM_APP] = true
//                        self.registerUser(parameters: paramDisc)
//                    }
                }
            })
        }
        else {
            Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_internet", comment: ""), message: "")
        }
    }
    
    
    func saveInDefaults(loggedInUser:RegisterDetails) {
        
        
        UserDefault.setUserId(loggedInUser._id)
        UserDefault.setLoginUserName(loggedInUser.name)
       // UserDefault.setLoginUserName(loggedInUser.fullname)
        UserDefault.setLoginUserProfile(loggedInUser.full_path)
        UserDefault.setLoginUserEmail(loggedInUser.email)
        UserDefault.setLoginUserMONumber(loggedInUser.phone)

        UserDefault.setReceiveNotification(loggedInUser.receive_notification)
        
        //        UserDefaults.standard.setValue(loggedInUser._id, forKey: USERID)
        //        UserDefaults.standard.setValue(loggedInUser.name, forKey: NAME)
        //        UserDefaults.standard.setValue(loggedInUser.full_path, forKey: USERPROFILE)
        //        UserDefaults.standard.setValue(loggedInUser.fullname, forKey: FULLNAME)
        //        UserDefaults.standard.setValue(loggedInUser.email, forKey:USEREMAIL)
        
        
        
        UserDefaults.standard.setValue(true, forKey: LOGINSTATUS)
        NavigationController.NavigateToBottomTabbarVC(self)
    }
}

extension LoginViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailIdTF {
            _ = self.passwordTF.becomeFirstResponder()
        }
        else if textField == self.passwordTF {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            self.registerBtnBottomConstraint.constant =  appDelegate.window!.frame.size.height <= 800.0 ? CGFloat(keyboardSize.height / 1.2 ) : CGFloat(keyboardSize.height / 2  + kBottomViewPadding)
            
              print(self.registerBtnBottomConstraint.constant)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        self.registerBtnBottomConstraint.constant =  appDelegate.window!.frame.size.height <= 800.0 ? kBottomViewPadding : kBottomViewPadding * 1.7
    }
}

//extension LoginViewController : GIDSignInUIDelegate {
//
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
//        // ...
//
//        print(user.authentication.clientID)
//        if let error = error {
//            // ...
//            return
//        }
//
//        guard let authentication = user.authentication else { return }
//        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                       accessToken: authentication.accessToken)
//        // ...
//        Auth.auth().signIn(with: credential) { (authResult, error) in
//            if let error = error {
//                // ...
//                return
//            }
//
//
//            // User is signed in
//            // ...
//        }
//    }
//
//
//
//    func sign(_ signIn: GIDSignIn?, present viewController: UIViewController?) {
//
//        // Showing OAuth2 authentication window
//        if let aController = viewController {
//            present(aController, animated: true) {() -> Void in }
//        }
//    }
//    // After Google OAuth2 authentication
//    func sign(_ signIn: GIDSignIn?, dismiss viewController: UIViewController?) {
//        // Close OAuth2 authentication window
//        dismiss(animated: true) {() -> Void in }
//    }
//}

//extension LoginViewController {
//
//    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
//
//        if ((error) != nil)
//        {
//            // Process error
//        }
//        else if result!.isCancelled {
//            // Handle cancellations
//        }
//        else {
//            // If you ask for multiple permissions at once, you
//            // should check if specific permissions missing
//            if result!.grantedPermissions.contains("email")
//            {
//                // Do work
//            }
//        }
//
//    }
//    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
//
//    }
//}

extension LoginViewController {
    
    func registerUser(parameters: [String:Any]) {
        if Reachability.isConnectedToNetwork() {
            WebServices.sharedInstance.registerUser(parameters, completionHandler: { (registerDetails:JSON,statusCode:Int) -> Void in
                
                
                self.register = RegisterDetails.init(registersjson:registerDetails)
                
                // self.register = RegisterDetails.getRegisterjson(registerJSON: registerDetails)
                self.saveInDefaults(loggedInUser:self.register!)
            })
        }
        else {
            Utility.ShowAlert(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: " no_internet", comment: ""), message: "")
        }
    }
}

