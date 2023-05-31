//
//  UserGuideViewController.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 04/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit
import SwiftyGif

class UserGuideViewController: UIViewController {

    var UserGuideModels =  UserGuideModel()
    
    var titleArray:[String] = ["Title","Title","Title"]
    var descArray:[String] = ["Lorem Ipsum is simply dummy text of the printing and typesetting industry.","Lorem Ipsum is simply dummy text of the printing and typesetting industry.","Lorem Ipsum is simply dummy text of the printing and typesetting industry."]
    
    var index = 0
    @IBOutlet weak var backgroundgif: UIImageView!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var userGuideCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
      
    }
    

    @IBAction func Previous_Tapped(_ sender: Any) {
          NavigationController.NavigateToLogin(self)
//     if index > 0 && index <= self.galleryArray.count - 1 {
//        index = index - 1
//        pageControl.progress = Double(index)
//      //  if index == 0 {
//       // self.previousBtn.setTitle("Skip", for: .normal) }
//        //else {
//          //   self.previousBtn.setTitle("Previous", for: .normal)
//        //}
//        userGuideCollection.scrollToItem(at: IndexPath.init(item: index, section: 0), at: .right, animated: true)
//        }
    }
    
    @IBAction func Next_Tapped(_ sender: Any) {
        self.NextUserGuide()
    }
}
extension UserGuideViewController {
    
    func setupView() {
        self.nextBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "next", comment: ""), for: .normal) 
   
        
        do {
            let gif = try UIImage(gifName: "background_video.gif")
            self.backgroundgif.setGifImage(gif)
        } catch {
            print(error)
        }
        
        UserDefaults.standard.setValue(true, forKey: USERGUIDSTATUS)
        if index == 0 {
        self.previousBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "skip", comment: ""), for: .normal)
        
        }
       
        self.userGuideCollection.register(UINib(nibName: "UserGuideCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "UserGuideCollectionViewCell")
    }
   
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
          
            default:
                print("other swipe")
            }
        }
    }
    
    func NextUserGuide() {
        if index != self.titleArray.count - 1 {
            //self.previousBtn.setTitle("Previous", for: .normal)
            index = index + 1
            if index == self.titleArray.count - 1 {
                self.nextBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "done", comment: ""), for: .normal) }
               
            
            else {
                self.nextBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "next", comment: ""), for: .normal) }
                
            userGuideCollection.scrollToItem(at: IndexPath.init(item: index, section: 0), at: .right, animated: true)
        }
        else if index == self.titleArray.count - 1  {
            NavigationController.NavigateToLogin(self)
        }
    }
    func PreviousUserGuide() {
        
    }
    
}

extension UserGuideViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserGuideModels.userguideArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:UserGuideCollectionViewCell = self.userGuideCollection.dequeueReusableCell(withReuseIdentifier: "UserGuideCollectionViewCell", for: indexPath) as! UserGuideCollectionViewCell
   
        cell.setupCell(userguide: UserGuideModels.userguideArray[indexPath.row],indexpath:indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.userGuideCollection.frame.size.width, height: self.userGuideCollection.frame.size.height)
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let visibleIndex = Int(targetContentOffset.pointee.x / self.userGuideCollection.frame.width)
        
        
        if visibleIndex != self.titleArray.count {
            index = visibleIndex
            if visibleIndex == self.titleArray.count - 1 {
            self.nextBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "done", comment: ""), for: .normal)
                
            }
            else {
                self.nextBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "next", comment: ""), for: .normal)
                
                
            }
            userGuideCollection.scrollToItem(at: IndexPath.init(item: visibleIndex, section: 0), at: .top, animated: true)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//         print(indexPath.row)
//    }
    
   
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//
//    }
    

    
}
