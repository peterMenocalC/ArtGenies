//
//  CustomPopViewController.swift
//  STEMdots
//
//  Created by 97 on 21/02/18.
//  Copyright © 2018 Appstute. All rights reserved.
//

import UIKit

class CustomPopViewController: UIViewController {

    
    @IBOutlet var mainView: UIView!
    @IBOutlet var innerView: UIView!
    @IBOutlet var tableView: UITableView!
    var indexs = [Indexs]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
          self.setup()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func PopCancel_Tapped(_ sender: Any)
    {
         
         self.dismiss(animated: true, completion: nil)
    }
}

extension CustomPopViewController
{
    func setup()
    {
        let nib = UINib(nibName: "CustomPopListTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "CustomPopListTableViewCell")
    }
}

extension CustomPopViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.indexs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CustomPopListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomPopListTableViewCell") as! CustomPopListTableViewCell
        cell.setupCell(indexs:self.indexs[indexPath.row])
        return cell
    }
}
