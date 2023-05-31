//
//  SceneCollectionViewCell.swift
//  12-Line-Wonder
//
//  Created by 97 on 07/02/18.
//  Copyright © 2018 Appstute. All rights reserved.
//

import UIKit

class SceneCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgPhoto: UIImageView!
    
    @IBOutlet weak var internalMalLbl: UILabel!
    
    override func awakeFromNib() {
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        
        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGest)
        
        super.awakeFromNib()
        // Initialization code
    }

}

extension SceneCollectionViewCell:UIScrollViewDelegate {
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imgPhoto.frame.size.height / scale
        zoomRect.size.width  = imgPhoto.frame.size.width  / scale
        let newCenter = imgPhoto.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imgPhoto
    }
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
    }
    
    func setupCell(internalmaps:InternalMaps) {
        
        if let urlStringfp = internalmaps.full_path {
            self.imgPhoto.sd_setImage(with: URL(string: urlStringfp), placeholderImage: UIImage(contentsOfFile: ""))
        }
        if let internalmap = internalmaps.name {
            self.internalMalLbl.text = internalmap
        }
    }
    
}
