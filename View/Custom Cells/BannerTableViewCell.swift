//
//  BannerTableViewCell.swift
//  ArtGenies
//
//  Created by Abhay Bachche on 12/09/19.
//  Copyright © 2019 Abhay Bachche. All rights reserved.
//

import UIKit

class BannerTableViewCell: UITableViewCell {

    @IBOutlet weak var BannerCollectionViewCell: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.BannerCollectionViewCell.register(UINib(nibName: "BannerCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "BannerCollectionViewCell")
        
        // Initialization code
    }

   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension BannerTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:BannerCollectionViewCell = self.BannerCollectionViewCell.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = self.BannerCollectionViewCell.bounds.width
        let yourHeight = self.BannerCollectionViewCell.bounds.height
        return CGSize(width: yourWidth, height: yourHeight)
    }
}




