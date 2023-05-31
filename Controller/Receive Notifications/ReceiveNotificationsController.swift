//
//  ReceiveNotificationsController.swift
//  ArtGenies
//
//  Created by Abhay Bachche on 30/10/19.
//  Copyright © 2019 Abhay Bachche. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReceiveNotificationsController: UIViewController {
    
    @IBOutlet weak var popupview: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var reciveNotiDesc: UILabel!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var switchStatus: UISwitch!
    var profileInfo:RegisterDetails!
    var statusChangeLbl:Bool!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func Switch_onChanged(_ sender: Any) {
        if self.switchStatus.isOn {
            statusChangeLbl = true
            self.UpdateReceiveNotification(parameters:statusChangeLbl)
            
        }
        else {
            statusChangeLbl = false
            self.UpdateReceiveNotification(parameters:statusChangeLbl)
        }
    }
    
    @IBAction func CancelBtn_Tapped(_ sender: Any) {
        
        removeAnimate()
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

extension ReceiveNotificationsController {
    
    func setupView() {
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.titleLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "receive_notifications", comment: "")
        self.reciveNotiDesc.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "receive_notifi_desc", comment: "")
        self.cancelBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "cancel", comment: ""), for: .normal)
        
        if let status = UserDefault.getReceiveNotification() {
            
            self.switchStatus.setOn(status, animated: false)
        }
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    func UpdateReceiveNotification(parameters:Bool)
    {
        var userDisc = [String:Any]()
        var paramDisc = [String:Any]()
        userDisc[RECEIVE_NOTIFICATION] = parameters
        paramDisc["user"] = userDisc
        
        WebServices.sharedInstance.editUser(UserDefault.getUserId()!,paramDisc,completionHandler: { (editUserDetails:JSON,statusCode:Int) -> Void in
            
            
            DispatchQueue.main.async {
                self.profileInfo = RegisterDetails.init(registersjson:editUserDetails[DATA])
                self.switchStatus.setOn(self.profileInfo.receive_notification!, animated: false)
                
                UserDefault.setReceiveNotification(self.profileInfo.receive_notification)
            }
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        removeAnimate()
    }
}
