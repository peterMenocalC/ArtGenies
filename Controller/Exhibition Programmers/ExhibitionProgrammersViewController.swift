//
//  ExhibitionProgrammersViewController.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 05/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit
import SDWebImage

class ExhibitionProgrammersViewController: UIViewController {
    
    @IBOutlet weak var BackBtn: UIBarButtonItem!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var exhibitionTableView: UITableView!
    
    @IBOutlet var notFoundLbl: UILabel!
    
  //  var exhibitionArray:[Int] = [1]
    var programmes = [Programs]()
    var exhibitionprogrammes:String!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func BackBtn_Tapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ExhibitionProgrammersViewController {
    
    func setupView() {
        
        
        self.TitleLbl.text = exhibitionprogrammes
//        let nib = UINib(nibName: "ExhibitionTableViewCell", bundle: nil)
//        self.exhibitionTableView.register(nib, forCellReuseIdentifier: "ExhibitionTableViewCell")

        let nib = UINib(nibName: "ExhibitionProgrammersTableViewCell", bundle: nil)
        self.exhibitionTableView.register(nib, forCellReuseIdentifier: "ExhibitionProgrammersTableViewCell")
        
        
        if self.programmes.count == 0 {
            self.notFoundLbl.isHidden = false
        }
        self.exhibitionTableView.reloadData()
    }
}

extension ExhibitionProgrammersViewController : UITableViewDataSource, UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.exhibitionArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell:ExhibitionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ExhibitionTableViewCell") as! ExhibitionTableViewCell
//
//        cell.setupCellProgramms(programmes:programmes)
//
//    //    cell.setupCell(index:self.exhibitionArray[indexPath.row])
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 270
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.programmes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ExhibitionProgrammersTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ExhibitionProgrammersTableViewCell") as! ExhibitionProgrammersTableViewCell
        
        cell.artImage!.sd_imageIndicator = SDWebImageActivityIndicator.large
        cell.artImage!.sd_imageIndicator = SDWebImageActivityIndicator.white
        cell.artImage!.sd_imageIndicator?.startAnimatingIndicator()

        cell.setupCell(program:programmes[indexPath.row])
        
        //    cell.setupCell(index:self.exhibitionArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
    
}

