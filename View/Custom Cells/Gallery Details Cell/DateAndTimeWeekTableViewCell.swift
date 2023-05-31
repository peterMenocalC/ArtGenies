//
//  DateAndTimeWeekTableViewCell.swift
//  ArtGenies
//
//  Created by Abhay Bachche on 08/09/19.
//  Copyright © 2019 Abhay Bachche. All rights reserved.
//

import UIKit

class DateAndTimeWeekTableViewCell: UITableViewCell {

    
    @IBOutlet weak var weekDayLbl: UILabel!
    @IBOutlet weak var weekTimeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var weekdayLeading: NSLayoutConstraint!
    @IBOutlet weak var weekdayWidth: NSLayoutConstraint!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension DateAndTimeWeekTableViewCell {
    
    func setupCellGalleryTime(timing:TimingDetails) {
    
        if let weekday = timing.day_of_week {
            self.weekDayLbl.text = weekday
        }
        
        self.weekTimeLbl.text = timing.openingTime + " - " + timing.closingTime
        
       // self.weekTimeLbl.text = timing.openingTime + " - " + timing.closingTime
        
//        print(opening)
        
        
//        if timing.opening! < 10.0 {
//
//            opentime = String(opening) + " " + "AM"
//            closetime = String(closing) + " " + "AM"
//        } else {
//            opentime = String(opening) + " " + "PM"
//            closetime = String(closing) + " " + "PM"
//        }
//        self.weekTimeLbl.text = opentime + " - " + closetime
    }
  
    func setupCellExhibition(exhibition:ExhibitionsDetails) {
        
        weekdayWidth.constant = 180
        weekTimeLbl.isHidden =  true
        
        
        if let startdate = exhibition.startdate {
            if let enddate = exhibition.enddate {
                
                self.weekDayLbl.text = Utility.UnixToDateString(timeStamp: startdate, dateFormat: Utility.DateFormat.Date) + "-" +
                Utility.UnixToDateString(timeStamp: enddate, dateFormat: Utility.DateFormat.Date)
            }
        }
    }
}

