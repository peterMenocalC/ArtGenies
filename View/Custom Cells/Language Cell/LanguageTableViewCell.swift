//
//  LanguageTableViewCell.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 04/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {

    @IBOutlet weak var langLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension LanguageTableViewCell {
    
    func setupCell(language:String,index:Int) {
        self.langLbl.text = language
    }
    func setupCellForDidSelect() {
        
        self.langLbl.textColor = .white
    }
    func setupCellForDidDeSelect() {
        self.langLbl.textColor = .lightGray
    }
}

