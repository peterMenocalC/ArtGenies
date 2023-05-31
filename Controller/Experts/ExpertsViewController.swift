//
//  ExpertsViewController.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 29/06/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit
import SwiftyJSON

class ExpertsViewController: UIViewController {

    @IBOutlet weak var expertsTableView: UITableView!
    var expertsArray:[Int] = [1,2,3,4,5]
    var categories:[CategoriesDetail]!
    var ExpertsDetail:[ExpertsDetails]!
    var expertCategories:String! = " "
    var getexpert:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    
        
       

        // Do any additional setup after loading the view.
    }

    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.getExpertsInfo()
    }
}


extension ExpertsViewController {
    
    
    func setupView() {

        categories.forEach { category in
            
            self.getexpert = category.name
        }
        self.expertCategories = self.expertCategories + "," + self.getexpert
        
        print(self.expertCategories as Any)
        
        let nib = UINib(nibName: "ExpertsTableViewCell", bundle: nil)
        self.expertsTableView.register(nib, forCellReuseIdentifier: "ExpertsTableViewCell")
    }
}
extension ExpertsViewController {
    
    func getExpertsInfo() {

        if Reachability.isConnectedToNetwork() {

            WebServices.sharedInstance.getExpertsInfo(self.getexpert,completionHandler: { (expertDetails:JSON,statusCode:Int) -> Void in

                if statusCode == 200 {

                    print(expertDetails.count)


                    self.ExpertsDetail = ExpertsDetails.getGallerydetailjson(expertsjson: expertDetails[DATA])
                    self.expertsTableView.reloadData()
                }

                else if statusCode == 404 {

                }
            })
        }
        else {
           Utility.ShowAlert(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: " no_internet", comment: ""), message: "")
        }
    }
}
extension ExpertsViewController : UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.expertsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ExpertsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ExpertsTableViewCell") as! ExpertsTableViewCell
        cell.setupCell()
        return cell
    }
}
