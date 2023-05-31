
//
//  GalleryListModel().swift
//  ArtGenies
//
//  Created by Yash Tatiya on 04/08/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import Foundation

class GalleryListModel: NSObject {
    
    var galleryListArray = [GalleryLists]()
    var galleryListFilter = [GalleryLists]()
    
    func numberOfRowsInSection() -> Int {
        return galleryListArray.count
    }
}

