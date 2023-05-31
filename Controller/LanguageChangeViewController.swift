//
//  LanguageChangeViewController.swift
//  ArtGenies
//
//  Created by Abhay Bachche on 28/09/19.
//  Copyright © 2019 Abhay Bachche. All rights reserved.
//

import UIKit

class LanguageChangeViewController: UIViewController {
    
    var languageArray:[String] = ["English","French"]
    var langArrayKey :[String] = ["1","2"]
    var selectlangArray : [String:String] = ["1":"2"]
    
    @IBOutlet var languagetableview: UITableView!
    @IBOutlet weak var popupview: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        if LocalizationSystem.sharedInstance.getLanguage() == "fr" {
            selectlangArray = ["2":"French"]
        }
        else {
            selectlangArray = ["1":"English"]
        }
        self.languagetableview.reloadData()
        
        // Do any additional setup after loading the view.
    }
}

extension LanguageChangeViewController {
    
    func setupView() {
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let nib = UINib(nibName: "OptionQuizTableViewCell", bundle: nil)
        self.languagetableview.register(nib, forCellReuseIdentifier: "OptionQuizTableViewCell")
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        removeAnimate()
    }
}


extension LanguageChangeViewController : UITableViewDelegate, UITableViewDataSource,OptionQuizTableViewCellDelegate
{
    func didTapOption(cell: OptionQuizTableViewCell, indexPath: IndexPath, questionKey: String, selectedAnswer: String) {
        
        if selectlangArray[questionKey] != nil {
            selectlangArray.removeValue(forKey: questionKey)
        }
        selectlangArray.removeAll()
        selectlangArray[questionKey] = selectedAnswer
        self.languagetableview.reloadData()
        if languageArray[indexPath.row] == "French" {
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "fr")
            languageCode = "fr"
            UserDefault.setCountryCode(languageCode)
            removeAnimate()
            self.tabBarController?.tabBar.isHidden = true
            NavigationController.NavigateToBottomTabbarVC(self)
        }
        else {
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
            languageCode = "en"
            UserDefault.setCountryCode(languageCode)
            removeAnimate()
            self.tabBarController?.tabBar.isHidden = true
            NavigationController.NavigateToBottomTabbarVC(self)
        }
        
        
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.languageArray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:OptionQuizTableViewCell = tableView.dequeueReusableCell(withIdentifier: "OptionQuizTableViewCell") as! OptionQuizTableViewCell
        cell.indexPath = indexPath
        cell.delegate = self
        cell.selectlangArray = selectlangArray;
        cell.setupCell(language:self.languageArray[indexPath.row],quizQuestion:langArrayKey[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
