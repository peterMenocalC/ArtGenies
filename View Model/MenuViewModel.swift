//
//  MenuViewModel.swift
//  KnowTIFY
//
//  Created by Abhay Bachche on 28/09/18.
//  Copyright © 2018 Abhay Bachche. All rights reserved.
//

import Foundation

class MenuViewModel: NSObject {
    
    var menuArray = [Menu]()
    
    override init() {
     

        let menu1 = Menu(menu_name: LocalizationSystem.sharedInstance.localizedStringForKey(key: "edit_profile", comment: ""), menu_deselect: "home_deselect.png",menu_select: "home_select.png")
        let menu2 = Menu(menu_name: LocalizationSystem.sharedInstance.localizedStringForKey(key: "scanned_arts", comment: ""), menu_deselect: "profile_deselect.png", menu_select: "profile_select.png")
        let menu3 = Menu(menu_name: LocalizationSystem.sharedInstance.localizedStringForKey(key: "change_language", comment: ""), menu_deselect: "joinnb_deselect.png", menu_select: "joinnb_select.png")
         let menu4 = Menu(menu_name: LocalizationSystem.sharedInstance.localizedStringForKey(key: "receive_notifications", comment: ""), menu_deselect: "joinnb_deselect.png", menu_select: "joinnb_select.png")
        let menu5 = Menu(menu_name: LocalizationSystem.sharedInstance.localizedStringForKey(key: "terms_and_conditions", comment: ""), menu_deselect: "faq_deselect.png", menu_select: "faq_select.png")
        let menu6 = Menu(menu_name: LocalizationSystem.sharedInstance.localizedStringForKey(key: "privacy_policy", comment: ""), menu_deselect: "faq_deselect.png", menu_select: "faq_select.png")
        let menu7 = Menu(menu_name: LocalizationSystem.sharedInstance.localizedStringForKey(key: "managed_policy", comment: ""), menu_deselect: "faq_deselect.png", menu_select: "faq_select.png")
        let menu8 = Menu(menu_name: LocalizationSystem.sharedInstance.localizedStringForKey(key: "version", comment: ""), menu_deselect: "faq_deselect.png", menu_select: "faq_select.png")
        let menu9 = Menu(menu_name: LocalizationSystem.sharedInstance.localizedStringForKey(key: "log_out", comment: ""), menu_deselect: "faq_deselect.png", menu_select: "faq_seleclog_outt.png")
        
        menuArray = [menu1, menu2, menu3, menu4,menu5,menu6,menu7,menu8,menu9]
    }
    
    func numberOfRowsInSection() -> Int {
        return menuArray.count
    }
}


