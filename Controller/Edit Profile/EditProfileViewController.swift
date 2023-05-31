//
//  EditProfileViewController.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 30/06/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import NVActivityIndicatorView
import MobileCoreServices
import Material
import SDWebImage

class EditProfileViewController: UIViewController {
    
    let kBottomViewPadding: CGFloat = 85.0
    @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
    var keyboardheight: CGFloat!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameTF: TextField!
    @IBOutlet weak var emailTF: TextField!
    @IBOutlet weak var mobilenumberTF: TextField!
    @IBOutlet var editprofileText: UILabel!
    @IBOutlet weak var errorusernameHeight: NSLayoutConstraint!
    @IBOutlet weak var errorusernameLbl: UILabel!
    @IBOutlet weak var erroremailLbl: UILabel!
    @IBOutlet weak var errorEmailErrorHeight: NSLayoutConstraint!
    @IBOutlet weak var errormobilenumberLbl: UILabel!
    @IBOutlet weak var errorMobileNumberErrorHeight: NSLayoutConstraint!
    @IBOutlet weak var submitBtnBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var doneButtonBottomLayout: NSLayoutConstraint!
    @IBOutlet weak var submitBtn: UIButton!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var profileInfo:RegisterDetails!
    var tapGesture = UITapGestureRecognizer()
    var pickedImage:UIImage!
    var oldimagename:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    
    @IBAction func Back_Tapped(_ sender: Any) {
        
        NavigationController.NavigateToStaticProfile(self)
        
        
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //
        //        if let vController = storyboard.instantiateViewController(withIdentifier: "StaticProfileViewController") as? StaticProfileViewController {
        //
        //        self.navigationController?.pushViewController(vController, animated: true)
        //
        //  self.navigationController?.popViewController(animated: true)
        
        //        for controller in self.navigationController!.viewControllers as Array {
        //
        //            print(controller)
        //
        //            if controller.isKind(of: StaticProfileViewController.self) {
        //                self.navigationController!.popToViewController(controller, animated: true)
        //                break
        //            }
    }
    @IBAction func ImgChange_Tapped(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: NSLocalizedString("upload_new_photo_actionsheet_title", comment: ""), message: "", preferredStyle: .actionSheet)
        // 2
        let cameraAction = UIAlertAction(title: NSLocalizedString("upload_new_photo_take_picture", comment: ""), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.presentImagePickerForType(UIImagePickerController.SourceType.camera)
        })
        let galleryAction = UIAlertAction(title: NSLocalizedString("upload_new_photo_select_image", comment: ""), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.presentImagePickerForType(UIImagePickerController.SourceType.photoLibrary)
            
        })
        //
        let cancelAction = UIAlertAction(title: NSLocalizedString("upload_photo_cancel", comment: ""), style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        // 4
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(galleryAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    @IBAction func Submit_Tapped(_ sender: Any) {
        
        if (self.usernameTF.text?.isEmpty)! {
            
            self.errorusernameHeight.constant = 20
            self.errorusernameLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "full_name_required", comment: "")
        }
        else {
            self.errorusernameHeight.constant = 00
        }
    
        if (!self.usernameTF.text!.isEmpty)
        {
            if (self.mobilenumberTF.text?.count ?? 0 > 0 && !Utility.isValidMobileNumber(self.mobilenumberTF.text!)) {
                self.errorMobileNumberErrorHeight.constant = 20
                self.errormobilenumberLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "mobile_not_valid", comment: "")
                return
            }
            else {
                 self.errorMobileNumberErrorHeight.constant = 00
            }
            
        self.view.endEditing(true)
        self.hideErrorLabels()
        var paramDisc = [String:Any]()
        var userDisc = [String:Any]()
        var usernameDisc = [String:Any]()
        usernameDisc["fr"] = self.usernameTF.text
        usernameDisc["en"] = self.usernameTF.text
        userDisc[UDID] = UserDefault.getUserId()
        userDisc[EMAIL] = self.emailTF.text
        userDisc[PHONE] = self.mobilenumberTF.text
        userDisc[NAME] = usernameDisc
        paramDisc["user"] = userDisc
        
        Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionAdd)
        
        WebServices.sharedInstance.editUser(UserDefault.getUserId()!,paramDisc,completionHandler: { (editUserDetails:JSON,statusCode:Int) -> Void in
            
             Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionRemove)
            
            DispatchQueue.main.async {
                
                self.profileInfo = RegisterDetails.init(registersjson:editUserDetails[DATA])
                
                Utility.ShowPopAlert(title: NSLocalizedString(LocalizationSystem.sharedInstance.localizedStringForKey(key: "successfully_upload", comment: ""), comment: ""), message: "",timeinseconds: 1.5)
                
                
                UserDefault.setLoginUserName(self.profileInfo.name)
              //  UserDefault.setLoginUserName(self.profileInfo.fullname)
                UserDefault.setLoginUserProfile(self.profileInfo.full_path)
                UserDefault.setLoginUserEmail(self.profileInfo.email)
                UserDefault.setLoginUserMONumber(self.profileInfo.phone)
                
                
                //AppDelegate.sharedInstance.profileInfo = self.profileInfo
                
               
            }
            
        })
        }
            
    }
}

extension EditProfileViewController {
    
    func setupView() {
        
        usernameTF.textColor = .white
        emailTF.textColor = .white
        mobilenumberTF.textColor = .white
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(EditProfileViewController.myviewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(tapGesture)
        scrollView.isUserInteractionEnabled = true
        
       self.submitBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "submit", comment: ""), for: .normal)
        self.editprofileText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "edit_profile", comment: "")
        Utility.setBorderAndCornerRadius(object:self.profileImg.layer, width: 0.3, radius:0, color: UIColor.gray)
        

        self.usernameTF.placeholderLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "full_name", comment: "")
        self.emailTF.placeholderLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "email_id", comment: "")
        
        self.mobilenumberTF.placeholderLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "mobile_number", comment: "")
        
    
        
        
        //Utility.setgradientLayer(object: self.submitBtn.layer, startcolor: "#A6A6FF", endcolor: "#421CFF")
        let tabBarHeight = tabBarController?.tabBar.frame.size.height
        print(tabBarHeight ?? "not defined")
        
//        self.submitBtnBottomConstraint.constant =  appDelegate.window!.frame.size.height <= 800.0 ? kBottomViewPadding - 80 : kBottomViewPadding * 1.1
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        self.hideErrorLabels()
    
        if let name = UserDefault.getLoginUserName() {
             self.usernameTF.text = name
             self.nameLbl.text = name
            
        }
        else if let fullname = UserDefault.getLoginUserFullName() {
           self.usernameTF.text = fullname
        }
        
        if let email = UserDefault.getLoginUserEmail() {
            self.emailTF.text = email
        }
        if let phone = UserDefault.getLoginUserMONumber() {
            self.mobilenumberTF.text = phone
        }
        
        self.profileImg!.sd_imageIndicator = SDWebImageActivityIndicator.large
        self.profileImg!.sd_imageIndicator = SDWebImageActivityIndicator.white
        self.profileImg!.sd_imageIndicator?.startAnimatingIndicator()
        
        if let userimgurl =  UserDefault.getLoginUserProfile() {
          // self.profileImg.sd_setImage(with: URL(string: userimgurl), placeholderImage: UIImage(imageNamed: "avatar.png"))
            if userimgurl == "" {
                
            }
            else {
                self.profileImg.sd_setImage(with: URL(string: userimgurl), placeholderImage:UIImage(contentsOfFile:"avatar.png"))
            }
        }
    }
    
    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
    }
        
    func hideErrorLabels() {
        
        self.errorusernameHeight.constant = 0
        self.errorEmailErrorHeight.constant = 0
        self.errorMobileNumberErrorHeight.constant = 0
    }
        
        
        
        
//        if self.profileInfo != nil {
//
//            if let name = self.profileInfo.name {
//                self.usernameTF.text = name
//
//            }
//            if let email = self.profileInfo.email {
//                self.emailTF.text = email
//            }
//            if let phone = self.profileInfo.phone {
//
//                self.mobilenumberTF.text = phone
//            }
//
//
//            if let userimgurl = self.profileInfo.full_path {
//                self.profileImg.sd_setImage(with: URL(string: userimgurl), placeholderImage: UIImage(contentsOfFile: ""))
//            }
//        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
          self.keyboardheight = keyboardSize.height
            
            //self.profileImg.alpha = 0
//            self.submitBtnBottomConstraint.constant =  appDelegate.window!.frame.size.height <= 800.0 ? CGFloat(keyboardSize.height / 1.1 ) : CGFloat(keyboardSize.height / 1.8  + kBottomViewPadding)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
       // self.profileImg.alpha = 1
//        self.submitBtnBottomConstraint.constant =  appDelegate.window!.frame.size.height <= 800.0 ? kBottomViewPadding - 80 : kBottomViewPadding * 1.1
    }
}


extension EditProfileViewController : UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    
    func presentImagePickerForType(_ type: UIImagePickerController.SourceType) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type
        picker.allowsEditing = true
        picker.mediaTypes = [String(kUTTypeImage)]
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            self.pickedImage = image
            
            // self.profileImg?.image = pickedImage
            
            self.dismiss(animated: true, completion: nil)
            
            self.uploadProfilephoto()
        }
    }
  
    
    func uploadProfilephoto() {
       
        let imageData = self.pickedImage!.jpegData(compressionQuality: 0)
        let dataDecoded = imageData!.base64EncodedString()
        
        if let userimgurl =  UserDefault.getLoginUserProfile() {
            
            self.oldimagename = userimgurl.subString(userimgurl.index(at: 43)...)
        }
        else {
           self.oldimagename = "1573120548.jpeg"
        }
        
        var fileDisc = [String:Any]()
        fileDisc[FILE] = [DATA:"data:image/jpeg;base64," + dataDecoded,FILEFOR:USER,OLDIMAGENAME: self.oldimagename]
        
        //        var userDisc = [String:Any]()
        //        var usernameDisc = [String:Any]()
        //     //   usernameDisc[languageCode] = self.usernameTF.text
        //        userDisc[USER] = [EMAIL:self.emailTF.text as Any,UDID:UserDefault.getUserId() as Any,PHONE: self.mobilenumberTF as Any,USERNAME:usernameDisc]
        //
        //        print(usernameDisc)
        //
        
        //   Utility.NVActivityStartAnimation(self.profileImg!)
        
        self.profileImg!.sd_imageIndicator = SDWebImageActivityIndicator.large
        self.profileImg!.sd_imageIndicator = SDWebImageActivityIndicator.white
        self.profileImg!.sd_imageIndicator?.startAnimatingIndicator()
        
        
        editUser(imgparameters: fileDisc)
        
    }
}

extension EditProfileViewController {
    
    func editUser(imgparameters: [String:Any]) {
        if Reachability.isConnectedToNetwork() {
            WebServices.sharedInstance.editUserImageUpload(imgparameters,completionHandler: { (registerDetails:JSON,statusCode:Int) -> Void in
                
                if statusCode == 200 {
                    
                    let object = registerDetails[DATA].dictionaryObject
                    let oripath = object!["ori_path"]
                    let thumbpath = object!["thumb_path"]
                    var paramDisc = [String:Any]()
                    var user = [String:Any]()
                    user[FULLPATH] =  oripath
                    user[THUMBPATH] = thumbpath
                    paramDisc["user"] = user
                   
                    //let newthumbpath:String =  object!["oripath"] as! String
                  
                    DispatchQueue.main.async {
                        self.profileImg.sd_setImage(with: URL(string: oripath as! String), placeholderImage: UIImage(contentsOfFile: ""))
                        
                        UserDefault.setLoginUserProfile((oripath as! String))
                        
                    }
                    WebServices.sharedInstance.editUser(UserDefault.getUserId()!,paramDisc,completionHandler: { (editUserDetails:JSON,statusCode:Int) -> Void in
                        
                        if statusCode == 200 {
                            DispatchQueue.main.async {
                            
                            let object = editUserDetails[DATA].dictionaryObject
                                
                      
                                
                                
                            }
                        }
                        
                    })
                }
            })
        }
        else {
            Utility.ShowAlert(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: " no_internet", comment: ""), message: "")
        }
    }
}


extension EditProfileViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == self.usernameTF {
            _ = self.mobilenumberTF.becomeFirstResponder()
        }
        else if textField == self.mobilenumberTF {
            textField.resignFirstResponder()
        }
        return true
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.doneButtonBottomLayout.constant =  self.keyboardheight
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        self.doneButtonBottomLayout.constant = 5
//    }
}

extension String
{
    func subString <R> (_ range: R) -> String? where R : RangeExpression, String.Index == R.Bound
    {
        return String(self[range])
    }
    
    func index(at: Int) -> Index
    {
        return self.index(self.startIndex, offsetBy: at)
    }
}
