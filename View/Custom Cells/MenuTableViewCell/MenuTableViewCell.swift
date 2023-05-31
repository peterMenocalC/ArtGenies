//
//  MenuTableViewCell.swift
//  KnowTIFY
//
//  Created by Abhay Bachche on 28/09/18.
//  Copyright © 2018 Abhay Bachche. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuBgview: UIView!
    @IBOutlet weak var menuLbl: UILabel!
   // @IBOutlet weak var menuImage: UIImageView!
    
    var menuViewModels: Menu! {
        didSet {
            menuLbl?.text = menuViewModels.menu_name
//            menuImage.image = UIImage(named:menuViewModels.menu_deselect!)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension MenuTableViewCell {
    
    func setupCellForDidSelect(menuViewModels:Menu)
    {
        menuLbl.textColor = .white
        //menuImage.image = UIImage(named:menuViewModels.menu_select!)
        menuBgview.backgroundColor = .black
    }
    func setupCellForDidDeSelect(menuViewModels:Menu)
    {
        menuLbl.textColor = .white
       // menuImage.image = UIImage(named:menuViewModels.menu_deselect!)
        menuBgview.backgroundColor = Utility.hexStringToUIColor(hex: "#2D2D2D")
    }
}

