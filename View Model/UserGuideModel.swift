//
//  UserGuideModel.swift
//  ArtGenies
//
//  Created by Abhay Bachche on 25/10/19.
//  Copyright © 2019 Abhay Bachche. All rights reserved.
//

import Foundation

class UserGuideModel: NSObject {
    
    var userguideArray = [Userguide]()
    
    override init() {
        
        let guide1 = Userguide(icon: "scan.png", userguidename: LocalizationSystem.sharedInstance.localizedStringForKey(key: "userguide1Title", comment: ""), userguidedesc: LocalizationSystem.sharedInstance.localizedStringForKey(key: "userguide1Desc", comment: ""))
        let guide2 = Userguide(icon: "likefill.png", userguidename: LocalizationSystem.sharedInstance.localizedStringForKey(key: "userguide2Title", comment: ""), userguidedesc: LocalizationSystem.sharedInstance.localizedStringForKey(key: "userguide2Desc", comment: ""))
        let guide3 = Userguide(icon: "share.png", userguidename: LocalizationSystem.sharedInstance.localizedStringForKey(key: "userguide3Title", comment: ""), userguidedesc: LocalizationSystem.sharedInstance.localizedStringForKey(key: "userguide3Desc", comment: ""))
        
        userguideArray = [guide1, guide2, guide3]
    }
    
    func numberOfRowsInSection() -> Int {
        return userguideArray.count
    }
}
