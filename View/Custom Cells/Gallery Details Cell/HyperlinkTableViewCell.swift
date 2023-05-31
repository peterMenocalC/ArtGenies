//
//  HyperlinkTableViewCell.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 10/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//


protocol HyperlinkTableViewCellDelegate {
    
    func hyperlinkClicked(cell:HyperlinkTableViewCell,indexPath:IndexPath,weblink:String)
}

import UIKit

class HyperlinkTableViewCell: UITableViewCell {

    var indexPath: IndexPath!
    var delegate : HyperlinkTableViewCellDelegate?
    
    @IBOutlet weak var hyperlinkBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func hyperLinkBtn_Tapped(_ sender: Any) {
        
        self.delegate?.hyperlinkClicked(cell: self, indexPath: indexPath, weblink: self.hyperlinkBtn.titleLabel!.text!)
    }
}

extension HyperlinkTableViewCell {
    func setupCell(_ weblink:String) {
        if weblink.contains("http://") ||  weblink.contains("https://")  {
            self.hyperlinkBtn.setTitle(weblink, for: .normal)
        }
        else {
            self.hyperlinkBtn.setTitle( "http://" + weblink, for: .normal)
        }
    
        
       // self.hyperlinkBtn.setTitle(weblink, for: .normal)
        
    }
}
