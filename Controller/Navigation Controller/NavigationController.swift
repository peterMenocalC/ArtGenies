//
//  NavigationController.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 04/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit
import Foundation


class NavigationController: NSObject {
    
    class func navigateToLangSelection(_ viewController: UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vController = storyboard.instantiateViewController(withIdentifier: "LanguageSelectionViewController") as? LanguageSelectionViewController{
            viewController.navigationController?.pushViewController(vController, animated: true)
        }
    }
    
    class func navigateToUserGuide(_ viewController: UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vController = storyboard.instantiateViewController(withIdentifier: "UserGuideViewController") as? UserGuideViewController{
            viewController.navigationController?.pushViewController(vController, animated: true)
        }
    }
    
    
    class func NavigateToLogin(_ viewController: UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController{
            viewController.navigationController?.pushViewController(vController, animated: true)
        }
    }
    
    class func navigateToRegister(_ viewController: UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vController = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController{
            viewController.navigationController?.pushViewController(vController, animated: true)
        }
    }
    class func navigateToScanImage(_ viewController: UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vController = storyboard.instantiateViewController(withIdentifier: "ScanImageViewController") as? ScanImageViewController{
            viewController.navigationController?.pushViewController(vController, animated: true)
        }
    }
    
    class func NavigateToAboutArtist(_ viewController: UIViewController,_ artistID:String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vController = storyboard.instantiateViewController(withIdentifier: "AboutArtistViewController") as? AboutArtistViewController{
            vController.artistID = artistID
            viewController.navigationController?.pushViewController(vController, animated: true)
        }
    }
    
    class func navigateToInstagramLoginVC(_ viewController: UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vController = storyboard.instantiateViewController(withIdentifier: "InstagramLoginVC") as? InstagramLoginVC{
            viewController.navigationController?.pushViewController(vController, animated: true)
        }
    }
    
    class func NavigateToPrivacyPolicy(_ viewController: UIViewController,_ registerPage:Bool){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vController = storyboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as? PrivacyPolicyViewController{
            vController.registerPage = registerPage
            viewController.navigationController?.pushViewController(vController, animated: true)
        }
    }
    
    class func navigateToBottomTabbarVC(_ viewController: UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vController = storyboard.instantiateViewController(withIdentifier: "BottomTabbarVC") as? BottomTabbarViewController {
            viewController.navigationController?.pushViewController(vController, animated: true)
        }
    }
    
    class func NavigateToBottomTabbarVC(_ viewController: UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vController = storyboard.instantiateViewController(withIdentifier: "BottomTabbarVC") as? BottomTabbarViewController {
            viewController.navigationController?.pushViewController(vController, animated: true)
        }
    }
    
    class func NavigateToGalleryDetails(_ viewController: UIViewController,_ galleryID:String,_ galleryorexhibition:String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vController = storyboard.instantiateViewController(withIdentifier: "GalleryDetailsViewController") as? GalleryDetailsViewController {
            vController.galleryID = galleryID
            vController.galleryorexhibition = galleryorexhibition
            viewController.navigationController?.pushViewController(vController, animated: true)
        }
    }
    
    class func NavigateToForgotPassword(_ viewController: UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vController = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController {
            viewController.navigationController?.pushViewController(vController, animated: true)
        }
    }
    
    
    
    
    class func NavigateToStaticProfile(_ viewController: UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vController = storyboard.instantiateViewController(withIdentifier: "StaticProfileViewController") as? StaticProfileViewController {
            viewController.navigationController?.pushViewController(vController, animated: true)
        }
    }
    
    class func NavigateToExhibitionProgrammers(_ viewController: UIViewController,_ programmes:[Programs],_ exhibitionprogrammes:String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vController = storyboard.instantiateViewController(withIdentifier: "ExhibitionProgrammersViewController") as? ExhibitionProgrammersViewController {
            vController.exhibitionprogrammes = exhibitionprogrammes
            vController.programmes = programmes
            viewController.navigationController?.pushViewController(vController, animated: true)
        }
    }
    
//    class func NavigateToYoutubePlayer(_ viewController: UIViewController,_ videoUrl:String){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let vController = storyboard.instantiateViewController(withIdentifier: "YoutubeVideoController") as? YoutubeVideoController {
//            vController.videoUrl = videoUrl
//            viewController.navigationController?.pushViewController(vController, animated: true)
//        }
//    }
    
    
    class func NavigateToInternalMap(_ viewController: UIViewController,_ internalmaps:[InternalMaps]){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vController = storyboard.instantiateViewController(withIdentifier: "InternalMapViewController") as? InternalMapViewController {
             vController.internalmaps = internalmaps
            viewController.navigationController?.pushViewController(vController, animated: true)
        }
    }
    class func NavigateToMap(_ viewController: UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as?  MapViewController {
            viewController.navigationController?.pushViewController(vController, animated: true)
        }
    }
   
    class func NavigateToPreview(_ viewController: UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vController = storyboard.instantiateViewController(withIdentifier: "GalleryExhibitionPreviewViewController") as? GalleryExhibitionPreviewViewController {
            viewController.navigationController?.pushViewController(vController, animated: true)
        }
    }
    
    
    class func NavigateToSWReveal(_ viewController:UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController {
            viewController.navigationController?.pushViewController(vController, animated: true)
        }
    }
    
    class func NavigateToGalleryAndExhibition(_ viewController: UIViewController,_ galleryorexhibition:String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vController = storyboard.instantiateViewController(withIdentifier: "GalleryAndExhibitionViewController") as? GalleryAndExhibitionViewController {
            vController.galleryorexhibition = galleryorexhibition
            viewController.navigationController?.pushViewController(vController, animated: true)
        }
    }
    
    class func NavigateToArtInfo(_ viewController: UIViewController,_ artid:String,_ gallerygostatus:String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vController = storyboard.instantiateViewController(withIdentifier: "ArtInfoViewController") as? ArtInfoViewController {
            vController.artId = artid
            vController.gallerygostatus = gallerygostatus
            viewController.navigationController?.pushViewController(vController, animated: true)
        }
    }
    
    class func NavigateToSearchArt(_ viewController: UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vController = storyboard.instantiateViewController(withIdentifier: "SearchArtViewController") as? SearchArtViewController {
            viewController.navigationController?.pushViewController(vController, animated: true)
        }
    }
    
    class func NavigateToArtInfoScan(_ viewController: UIViewController,_ cameraScan:Bool,_ artinfodetail:ArtInfoDetails){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vController = storyboard.instantiateViewController(withIdentifier: "ArtInfoViewController") as? ArtInfoViewController {
            vController.cameraScan = cameraScan
            vController.ArtInfoDetailScanning = artinfodetail
            viewController.navigationController?.pushViewController(vController, animated: true)
        }
    }
    
    class func NavigateToExperts(_ viewController: UIViewController,_ categories:[CategoriesDetail]) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vController = storyboard.instantiateViewController(withIdentifier: "ExpertsViewController") as? ExpertsViewController {
            vController.categories = categories
            
            
            viewController.navigationController?.pushViewController(vController, animated: true)
        }
    }
    
    
    class func NavigateToScanQRCode(_ viewController: UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vController = storyboard.instantiateViewController(withIdentifier: "QRScannerController") as? QRScannerController {
            viewController.navigationController?.pushViewController(vController, animated: true)
        }
    }
}

