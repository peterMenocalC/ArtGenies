//
//  OptionQuizTableViewCell.swift
//  STEMdotsFirebase
//
//  Created by 97 on 21/03/18.
//  Copyright © 2018 Appstute. All rights reserved.
//

import UIKit

protocol OptionQuizTableViewCellDelegate {
    
    func didTapOption(cell:OptionQuizTableViewCell,indexPath:IndexPath,questionKey:String,selectedAnswer:String)
}

class OptionQuizTableViewCell: UITableViewCell {

    @IBOutlet weak var radioImgView: UIImageView!
    @IBOutlet weak var optionBtn: UIButton!
    @IBOutlet weak var optionLbl: UILabel!
    
    var delegate: OptionQuizTableViewCellDelegate?
    var questionKey = ""
    var selectlangArray = [String:String]()
    var indexPath:IndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func Option_Tapped(_ sender: Any) {
        
        self.radioImgView.image = UIImage(named: "radio-filled")
        self.delegate?.didTapOption(cell: self, indexPath: indexPath,questionKey:String(describing: indexPath.row + 1),selectedAnswer:self.optionLbl.text!)
        
    }
}
extension OptionQuizTableViewCell
{
    func setupCell(language:String,quizQuestion:String) {
        self.optionLbl.text = language
        
        if selectlangArray[quizQuestion] == language {
            self.radioImgView.image = UIImage(named: "radio-filled")
        }
        else {
            self.radioImgView.image = UIImage(named: "radio-unfilled")
        }
    }
}

        
        

