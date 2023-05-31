//
//  ExhibitionProgrammersMenuList.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 06/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit

struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

class ExhibitionProgrammersMenuList: UIViewController {
    
    @IBOutlet weak var exhibitionProgsTableView: UITableView!
    
    var tableViewData = [cellData]()
    
    var exhibitionProgsArray:[Int] = [1,2,3,4,5]
    override func viewDidLoad() {
         self.setupView()
        super.viewDidLoad()
  
        tableViewData = [cellData(opened: false, title: "Events of Day - 1", sectionData:["Cell1","Cell2","Cell3"]),
                        cellData(opened: false, title: "Events of Day - 2", sectionData: ["Cell1","Cell2","Cell3"]),
                        cellData(opened: false, title: "Events of Day - 3", sectionData: ["Cell1","Cell2","Cell3"]),
                        cellData(opened: false, title: "Events of Day - 4", sectionData: ["Cell1","Cell2","Cell3"]),
                        cellData(opened: false, title: "Events of Day - 5", sectionData: ["Cell1","Cell2","Cell3"])]

        // Do any additional setup after loading the view.
    }
}

extension ExhibitionProgrammersMenuList {
    
    func setupView() {
        
        self.exhibitionProgsTableView.register(UINib(nibName: "ExhibitionProgrsMenuListTableViewCell", bundle: nil), forCellReuseIdentifier: "ExhibitionProgrsMenuListTableViewCell")
        self.exhibitionProgsTableView.register(UINib(nibName: "EventNameTableViewCell", bundle: nil), forCellReuseIdentifier: "EventNameTableViewCell")
    }
}

extension ExhibitionProgrammersMenuList : UITableViewDataSource, UITableViewDelegate, QuizQuestionCollectionViewCellDelegate {
    func optionSelected(cell: ExhibitionProgrsMenuListTableViewCell, indexPath: IndexPath) {
        if indexPath.row == 0 {
        if tableViewData[indexPath.section].opened == true {
            tableViewData[indexPath.section].opened = false
            let sections = IndexSet.init(integer: indexPath.section)
            exhibitionProgsTableView.reloadSections(sections, with: .none)
        }
        else {
            tableViewData[indexPath.section].opened = true
            let sections = IndexSet.init(integer: indexPath.section)
            exhibitionProgsTableView.reloadSections(sections, with: .none)
        }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
      return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true {
            return tableViewData[section].sectionData.count
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell:ExhibitionProgrsMenuListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ExhibitionProgrsMenuListTableViewCell") as! ExhibitionProgrsMenuListTableViewCell
             cell.indexPath = indexPath
             cell.delegate = self
            return cell
        }
        else {
            let cell:EventNameTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EventNameTableViewCell") as! EventNameTableViewCell
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 {
            return 80
       // }
////        else {
////            return 20
////        }
////        return 0
    }
}

