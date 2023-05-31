//
//  LanguageSelectionViewController.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 04/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit
import SwiftyGif

class LanguageSelectionViewController: UIViewController {
    
    var languageArray:[String] = ["English","French"]
    @IBOutlet weak var backgroundgif: UIImageView!
    @IBOutlet weak var languageTableview: UITableView!
    @IBOutlet var selectLangLbl: UILabel!
    @IBOutlet var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
        languageCode = "en"
        UserDefault.setCountryCode(languageCode)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView(languageTableview, didSelectRowAt: indexPath)
        languageTableview.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
    }
    @IBAction func Next_Tapped(_ sender: Any) {
        NavigationController.navigateToUserGuide(self)
    }
}

extension LanguageSelectionViewController {
    
    func setupView() {
        
        do {
            let gif = try UIImage(gifName: "background_video.gif")
            self.backgroundgif.setGifImage(gif)
        } catch {
            print(error)
        }
        
        let nib = UINib(nibName: "LanguageTableViewCell", bundle: nil)
        self.languageTableview.register(nib, forCellReuseIdentifier: "LanguageTableViewCell")
    }
}



extension LanguageSelectionViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.languageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LanguageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LanguageTableViewCell") as! LanguageTableViewCell
        cell.setupCell(language:self.languageArray[indexPath.row],index:indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = languageTableview.cellForRow(at: indexPath) as! LanguageTableViewCell
        
        if languageArray[indexPath.row] == "French" {
            
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "fr")
            languageCode = "fr"
            UserDefault.setCountryCode(languageCode)
        }
        else {
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
            languageCode = "en"
            UserDefault.setCountryCode(languageCode)
        }
        cell.setupCellForDidSelect()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = languageTableview.cellForRow(at: indexPath) as! LanguageTableViewCell
        cell.setupCellForDidDeSelect()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
}

