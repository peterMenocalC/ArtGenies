//
//  InternalMapViewController.swift
//  ArtGenies
//
//  Created by Abhay Bachche on 13/09/19.
//  Copyright © 2019 Abhay Bachche. All rights reserved.
//

import UIKit
import MaterialShowcase
import SDWebImage

class InternalMapViewController: UIViewController {
    
    var internalmaps = [InternalMaps]()
    // var galleryArray:[Int] = [1,2,3]
    var index = 0
    
    @IBOutlet var zoominLbl: UILabel!
    
    @IBOutlet var internalMapCollectionView: UICollectionView!
    @IBOutlet var titleLblText: UILabel!
    
    @IBOutlet var internalMapBtn: UIBarButtonItem!
    
    var sequence = MaterialShowcaseSequence()
    
    var visibleIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let showcase1 = MaterialShowcase()
        showcase1.setTargetView(barButtonItem: internalMapBtn)
        showcase1.primaryText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "find", comment: "")
        showcase1.secondaryText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "find_on_map", comment: "")
        showcase1.isTapRecognizerForTargetView = true
        showcase1.targetTintColor = UIColor.blue
        showcase1.targetHolderRadius = 44
        showcase1.targetHolderColor = UIColor.clear
        showcase1.primaryTextColor = UIColor.white
        showcase1.secondaryTextColor = UIColor.white
        showcase1.primaryTextSize = 30
        showcase1.secondaryTextSize = 20
        showcase1.delegate = self
        sequence.temp(showcase1).setKey(key: "eve3").start()
        
    }
    
    
    @IBAction func Back_Tapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func fotoFever(_ sender: Any) {
        NavigationController.NavigateToGalleryDetails( self, "5db4769179d2902f47043274",EXHIBITION_DETAILS)
    }
    
    @IBAction func ListMap_Tapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let CustomPopView = storyboard.instantiateViewController(withIdentifier:"CustomPopViewController") as! CustomPopViewController
        CustomPopView.indexs = self.internalmaps[self.visibleIndex].indexs
        CustomPopView.modalPresentationStyle = .overCurrentContext
        self.present(CustomPopView, animated: true, completion: nil)
    }
}

extension InternalMapViewController {
    
    func setupView() {
        
        self.titleLblText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "exhibitionmap", comment: "")
         self.zoominLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "zoominzoomout", comment: "")
        
        self.internalMapCollectionView.register(UINib(nibName: "SceneCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "SceneCollectionViewCell")
    }
}

extension InternalMapViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return internalmaps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:SceneCollectionViewCell = self.internalMapCollectionView.dequeueReusableCell(withReuseIdentifier: "SceneCollectionViewCell", for: indexPath) as! SceneCollectionViewCell
        
        cell.imgPhoto!.sd_imageIndicator = SDWebImageActivityIndicator.large
        cell.imgPhoto!.sd_imageIndicator = SDWebImageActivityIndicator.white
        cell.imgPhoto!.sd_imageIndicator?.startAnimatingIndicator()
        cell.setupCell(internalmaps:self.internalmaps[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width, height: self.internalMapCollectionView.frame.size.height)
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
         self.visibleIndex = Int(targetContentOffset.pointee.x / self.internalMapCollectionView.frame.width)
    
        
        if self.visibleIndex != self.internalmaps.count {
            index = visibleIndex
            if visibleIndex == self.internalmaps.count - 1 {
                
            }
            else {
            }
            internalMapCollectionView.scrollToItem(at: IndexPath.init(item: self.visibleIndex, section: 0), at: .right, animated: true)
        }
    }
}

extension InternalMapViewController: MaterialShowcaseDelegate {
    func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
        sequence.showCaseWillDismis()
    }
}
