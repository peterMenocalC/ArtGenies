//
//  RegisterViewController.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 23/06/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit
import Material
import SwiftyJSON

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var usernameTF: TextField!
    @IBOutlet weak var emailTF: TextField!
    @IBOutlet weak var passwordTF: TextField!
    @IBOutlet weak var mobilenumberTF: TextField!
    @IBOutlet weak var errorusernameHeight: NSLayoutConstraint!
    @IBOutlet weak var errorusernameLbl: UILabel!
    @IBOutlet weak var erroremailLbl: UILabel!
    @IBOutlet weak var errorEmailErrorHeight: NSLayoutConstraint!
    @IBOutlet weak var errorPasswordLbl: UILabel!
    @IBOutlet weak var passwordErrorHeight: NSLayoutConstraint!
    @IBOutlet weak var errormobilenumberLbl: UILabel!
    @IBOutlet weak var errorMobileNumberErrorHeight: NSLayoutConstraint!
    @IBOutlet weak var registerBtnBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet var signinBtn: UIButton!
    var privacyChangeStatus:Bool!
    
    
    @IBOutlet var privacystatmentLbl: UILabel!

    @IBOutlet var privacySwitch: UISwitch!



    @IBOutlet var yourPrivacyHeadLbl: UILabel!

    @IBOutlet var purposeDescLbl: UILabel!

    @IBOutlet var purposeBootomLbl: UILabel!

//
//
//
    var register:RegisterDetails? = nil
    let kBottomViewPadding: CGFloat = 15.0
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
     var tapGesture = UITapGestureRecognizer()
    override func viewDidLoad() {
        self.setupView()

        tapGesture = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.myviewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(tapGesture)
        scrollView.isUserInteractionEnabled = true

        do {
            let gif = try UIImage(gifName: "background_video.gif")
            self.logoImg.setGifImage(gif)
        } catch {
            print(error)
        }
        
        usernameTF.delegate = self
        mobilenumberTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self //set delegate to textfile
//
//        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        super.viewDidLoad()
        
        
        //emailTF.text =   NSLocalizedString("login_button", comment: "")
        // NSLocalizedString("login_button", comment: "")
        // Do any additional setup after loading the view.
    }
    deinit {
        
        NotificationCenter.default.removeObserver(self);
    }
    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
    }
    @IBAction func Signup_Tapped(_ sender: Any) {


        if (self.usernameTF.text?.isEmpty)! {

            self.errorusernameHeight.constant = 20
            self.errorusernameLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "full_name_required", comment: "")
        }
        else {
            self.errorusernameHeight.constant = 00
        }

//        if (self.mobilenumberTF.text?.isEmpty)! || (self.mobilenumberTF.text?.count != 10) {
//
//            self.errorMobileNumberErrorHeight.constant = 20
//            self.errormobilenumberLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "mobile_required", comment: "")
//        }
//        else {
//            self.errorMobileNumberErrorHeight.constant = 00
//        }

        if (self.emailTF.text?.isEmpty)! || (!Utility.isValidEmail(self.emailTF.text!))  {

            self.errorEmailErrorHeight.constant = 20
            self.erroremailLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "email_required", comment: "")
        }
        else {
            self.errorEmailErrorHeight.constant = 0
        }

        if (self.passwordTF.text!.isEmpty) {

            self.passwordErrorHeight.constant = 20
            self.errorPasswordLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "password_required", comment: "")
        }

       else if (!Utility.isPasswordValid(self.passwordTF.text!)) {
            self.passwordErrorHeight.constant = 35
            self.errorPasswordLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "password_valid_error", comment: "")

        }
        else {
            self.passwordErrorHeight.constant = 0
        }
//        if ((self.mobilenumberTF.text?.count == 10) && (Utility.isValidEmail(self.emailTF.text!)) && (Utility.isPasswordValid(self.passwordTF.text!)))
//        {


        if ((Utility.isValidEmail(self.emailTF.text!)) && (Utility.isPasswordValid(self.passwordTF.text!)))
        {
            if (self.mobilenumberTF.text?.count ?? 0 > 0 && !Utility.isValidMobileNumber(self.mobilenumberTF.text!)) {
                Utility.ShowAlert(title: LocalizationSystem.sharedInstance.localizedStringForKey(key:"mobile_not_valid", comment: ""), message: "")
                return
            }
            self.hideErrorLabels()
            self.view.endEditing(true)
            var paramDisc = [String:Any]()
            var user = [String:Any]()

            var usernameDisc = [String:Any]()
            usernameDisc["fr"] = self.usernameTF.text
            usernameDisc["en"] = self.usernameTF.text
            user[NAME] = usernameDisc
            user[IS_EMAIL_VALIDATED] = false
            user[LANGUAGE] = languageCode
            user[EMAILID] = self.emailTF.text
            user[PASSWORD] = self.passwordTF.text
            user[MOBILENUMBER] = self.mobilenumberTF.text
            user[RECEIVE_NOTIFICATION] = privacyChangeStatus
            paramDisc[USER] = user
            paramDisc[IS_USER_FROM_APP] = true
            registerUser(parameters: paramDisc)
        }


        //NavigationController.navigateToLogin(self)


        // print(paramDisc)
    }

    @IBAction func Signin_Tapped(_ sender: Any) {
        NavigationController.NavigateToLogin(self)
    }

    @IBAction func Privacy_OnChanged(_ sender: Any) {
        if self.privacySwitch.isOn {
            privacyChangeStatus = true

        }
        else {
            privacyChangeStatus = false
        }
    }
}

extension RegisterViewController {

    func setupView() {

        usernameTF.textColor = .white
        emailTF.textColor = .white
        passwordTF.textColor = .white
        mobilenumberTF.textColor = .white

        self.usernameTF.placeholderLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "full_name", comment: "")
        self.emailTF.placeholderLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "email_id", comment: "")
        self.passwordTF.placeholderLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "password", comment: "")
        self.mobilenumberTF.placeholderLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "mobile_number", comment: "")

         self.yourPrivacyHeadLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Because_your_privacy", comment: "")
         self.purposeDescLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "privacy_desc", comment: "")
         self.purposeBootomLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "privacy_bootom_desc", comment: "")

        self.signinBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sign_in", comment: ""), for: .normal)
        self.signupBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sign_up", comment: ""), for: .normal)
//        Utility.setgradientLayer(object: self.signupBtn.layer, startcolor: "#210092", endcolor: "#2648f0")
        //self.registerBtnBottomConstraint.constant =  appDelegate.window!.frame.size.height <= 800.0 ? kBottomViewPadding * 3 : kBottomViewPadding * 5
        self.hideErrorLabels()

        let attributedText = NSMutableAttributedString.getAttributedString(fromString:LocalizationSystem.sharedInstance.localizedStringForKey(key: "privacy_statement", comment: ""))

         attributedText.underLine(subString: LocalizationSystem.sharedInstance.localizedStringForKey(key: "privacy_statement", comment: ""))
        self.privacystatmentLbl.attributedText = attributedText
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tapGesture.numberOfTapsRequired = 1
        privacystatmentLbl.isUserInteractionEnabled = true
        privacystatmentLbl.addGestureRecognizer(tapGesture)


    }
    func hideErrorLabels() {
        self.errorusernameHeight.constant = 0
        self.errorEmailErrorHeight.constant = 0
        self.passwordErrorHeight.constant = 0
      //  self.errorMobileNumberErrorHeight.constant = 0
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {

        NavigationController.NavigateToPrivacyPolicy(self,true)

    }
//    @objc func keyboardWillShow(_ notification: Notification) {
//
//
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//
//           // self.registerBtnBottomConstraint.constant =  appDelegate.window!.frame.size.height <= 800.0 ? CGFloat(keyboardSize.height / 1.4 ) : CGFloat(keyboardSize.height / 1.5  + kBottomViewPadding)
//        }
//    }
//
//    @objc func keyboardWillHide(_ notification: Notification) {
//
//       // self.registerBtnBottomConstraint.constant =  appDelegate.window!.frame.size.height <= 800.0 ? kBottomViewPadding * 3 : kBottomViewPadding * 5
//    }
}


extension RegisterViewController {

    func registerUser(parameters: [String:Any]) {
        if Reachability.isConnectedToNetwork() {
            WebServices.sharedInstance.registerUser(parameters, completionHandler: { (registerDetails:JSON,statusCode:Int) -> Void in

                if statusCode == 200 {
                    self.register = RegisterDetails.init(registersjson:registerDetails[DATA])
                    NavigationController.NavigateToLogin(self)
                    
                    Utility.ShowAlert(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "register_success_msg", comment: ""), message: "")
                }
                else if statusCode == 404  {
                    
                     Utility.ShowAlert(title: LocalizationSystem.sharedInstance.localizedStringForKey(key:  "already_present", comment: ""), message: "")
                }
            })
        }
        else {

            Utility.ShowAlert(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: " no_internet", comment: ""), message: "")
        }
    }
}

extension RegisterViewController : UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        if textField == self.usernameTF {
            _ = self.emailTF.becomeFirstResponder()
        }
        else if textField == self.emailTF {
            _ = self.passwordTF.becomeFirstResponder()
        }
        else if textField == self.passwordTF {
            _ = self.mobilenumberTF.becomeFirstResponder()
        }
        else if textField == self.mobilenumberTF {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension NSMutableAttributedString {

    public func setAsLink(textToFind:String, linkURL:String) -> Bool {

        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
