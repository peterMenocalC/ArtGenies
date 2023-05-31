//
//  DyanmicHyperlinkTableViewCell.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 17/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//


protocol DyanmicHyperlinkTableViewCellDelegate {
    
    func hyperlinkCell(cell:DyanmicHyperlinkTableViewCell,indexPath:IndexPath,weblink:String)
}

import UIKit

class DyanmicHyperlinkTableViewCell: UITableViewCell {

    var indexPath: IndexPath!
    var delegate : DyanmicHyperlinkTableViewCellDelegate?
    @IBOutlet weak var linkTableView: UITableView!
    var weblink = String()
    var identifyVC: String!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.linkTableView.register(UINib(nibName: "HyperlinkTableViewCell", bundle: nil), forCellReuseIdentifier: "HyperlinkTableViewCell")
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension DyanmicHyperlinkTableViewCell {
 
     func setupCellGalleryLink(gallery:GalleryDetails) {
        self.weblink = gallery.weblink
        self.linkTableView.reloadData()
    }
    func setupCellExhibitionLink(exhibition:ExhibitionsDetails) {
        self.weblink = exhibition.weblink
        self.linkTableView.reloadData()
    }
    func setupCellArtInfo(artinfodetails:ArtInfoDetails) {
        self.weblink = artinfodetails.weblink
        self.linkTableView.reloadData()
    }
}
extension DyanmicHyperlinkTableViewCell: UITableViewDataSource, UITableViewDelegate {
    
    //cells count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HyperlinkTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HyperlinkTableViewCell") as! HyperlinkTableViewCell
        cell.indexPath = indexPath
        cell.delegate = self
        cell.setupCell(self.weblink)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension DyanmicHyperlinkTableViewCell : HyperlinkTableViewCellDelegate {
    func hyperlinkClicked(cell: HyperlinkTableViewCell, indexPath: IndexPath,weblink:String) {
        self.delegate?.hyperlinkCell(cell: self, indexPath: indexPath, weblink: weblink)
    }
}

