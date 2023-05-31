//
//  ForgotPasswordViewController.swift
//  ArtGenies
//
//  Created by Abhay Bachche on 06/10/19.
//  Copyright © 2019 Abhay Bachche. All rights reserved.
//

import UIKit
import Material
import SwiftyJSON

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet var bgImg: UIImageView!
    
    @IBOutlet var emailTF: TextField!
    @IBOutlet var errorEmailLbl: UILabel!
    @IBOutlet var errorEmailErrorHeight: NSLayoutConstraint!
    @IBOutlet var ForgotPasswordBtn: UIButton!
    @IBOutlet var SignInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func ForgotPassword_Tapped(_ sender: Any) {
        
       
        
        if (self.emailTF.text?.isEmpty)! || (!Utility.isValidEmail(self.emailTF.text!))  {
            
            self.errorEmailErrorHeight.constant = 20
            self.errorEmailLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "email_required", comment: "")
        }
        else
        {
            self.hideErrorLabels()
            self.view.endEditing(true)
            var user = [String:Any]()
            user[EMAILID] = self.emailTF.text
            user[LANGUAGE] = languageCode
            forgotPassword(parameters: user)
        }
    }
    @IBAction func SignIn_Tapped(_ sender: Any) {
        
        NavigationController.NavigateToLogin(self)
        
    }
}


extension ForgotPasswordViewController {
    
    func setupView() {
        emailTF.delegate = self
        do {
            let gif = try UIImage(gifName: "background_video.gif")
            self.bgImg.setGifImage(gif)
        } catch {
            print(error)
        }
        
        self.hideErrorLabels()
        emailTF.textColor = .white
        self.emailTF.placeholderLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "email_id", comment: "")
        self.SignInBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sign_in", comment: ""), for: .normal)
       // Utility.setgradientLayer(object: self.ForgotPasswordBtn.layer, startcolor: "#210092", endcolor: "#2648f0")
        self.ForgotPasswordBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "forgot_password", comment: ""), for: .normal)
    }
    func hideErrorLabels() {
        self.errorEmailErrorHeight.constant = 0
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


extension ForgotPasswordViewController {
    
    func forgotPassword(parameters: [String:Any]) {
        
        if Reachability.isConnectedToNetwork() {
            
            Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionAdd)
            
            WebServices.sharedInstance.forgotPassword(parameters, completionHandler: { (registerDetails:JSON,statusCode:Int) -> Void in
                
                Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionRemove)
                
                if statusCode == 200 {
                    
                 Utility.ShowAlert(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "reset_password_sent", comment: ""), message: "")
                }
                else if statusCode == 404 {
                 
               Utility.ShowAlert(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "emailid_not_exist", comment: ""), message: "")
                    
                }
            })
        }
        else {
            
            Utility.ShowAlert(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: " no_internet", comment: ""), message: "")
        }
    }
}
extension ForgotPasswordViewController : UITextFieldDelegate{
    
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
}
