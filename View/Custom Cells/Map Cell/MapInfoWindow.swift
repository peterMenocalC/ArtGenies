//
//  MapInfoWindow.swift
//  GoogleMapsCustomInfoWindow
//
//  Created by Sofía Swidarowicz Andrade on 11/5/17.
//  Copyright © 2017 Sofía Swidarowicz Andrade. All rights reserved.
//

import UIKit

class MapInfoWindow: UIView {
    
    var GalleryMapsArray = [GalleryMaps]()
    @IBOutlet var mapImage: UIImageView!
    @IBOutlet var mapname: UILabel!
    
    @IBOutlet var mapstatus: UILabel!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MapInfoWindowView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
    
}

extension MapInfoWindow {
    
    func setupCellGallery(gallery:GalleryMaps)
    {
        if let galleryName =  gallery.name {
            self.mapname.text = galleryName
        }
        if let status =  gallery.status {
            self.mapstatus.text = status
        }
        if let urlStringfp = gallery.full_path {
            self.mapImage.sd_setImage(with: URL(string: urlStringfp), placeholderImage: UIImage(contentsOfFile: ""))
        }
    }
    
    
    func setupCellExhibition(exhibition:ExhibitionsMaps)
    {
        if let exhibitionName =  exhibition.name {
            self.mapname.text = exhibitionName
        }
        if let status =  exhibition.status {
            self.mapstatus.text = status
        }
        if let urlStringfp = exhibition.full_path {
            self.mapImage.sd_setImage(with: URL(string: urlStringfp), placeholderImage: UIImage(contentsOfFile: ""))
        }
    }
}
