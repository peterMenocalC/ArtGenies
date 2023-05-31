//
//  ExhibitionProgrammersTableViewCell.swift
//  ArtGenies
//
//  Created by Abhay Bachche on 08/10/19.
//  Copyright © 2019 Abhay Bachche. All rights reserved.
//

import UIKit

class ExhibitionProgrammersTableViewCell: UITableViewCell {
    
    @IBOutlet var artImage: UIImageView!
    @IBOutlet var bgView: UIView!
    @IBOutlet var artname: UILabel!
    @IBOutlet var arttime: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         Utility.setBorderAndCornerRadius(object:self.bgView.layer, width: 1, radius:0,color: UIColor.gray)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension ExhibitionProgrammersTableViewCell
{
    func setupCell(program:Programs)
    {
        if let name =  program.name {
            self.artname.text = name
        }
        
        if let urlString = program.full_path {
            self.artImage.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(contentsOfFile: ""))
        }
        
        if let starttime = program.starttime {
            if let endtime = program.endtime {
                let currentTimeStamp:Int = Int(Utility.getCurrentTimeInMilliSec())
                if Int(starttime) > currentTimeStamp {
                    self.arttime.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "upcomingws", comment: "")
                    self.arttime.textColor = UIColor.green
                    
                }
                else if Int(starttime) < currentTimeStamp && Int(endtime) > currentTimeStamp {
                    self.arttime.textColor = UIColor.green
                    self.arttime.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ongoingws", comment: "")
                    
                }
                else if Int(endtime) < currentTimeStamp {
                    self.arttime.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "completedws", comment: "")
                    self.arttime.textColor = UIColor.red
                }
            }
        }
    }
}

