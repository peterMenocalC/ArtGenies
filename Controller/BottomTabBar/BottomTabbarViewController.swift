//
//  BottomTabbarViewController.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 18/07/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit

class BottomTabbarViewController: UITabBarController,UITabBarControllerDelegate {
    
    var profileInfo:RegisterDetails!
    var window: UIWindow?
    var previousSelectedTabIndex:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.delegate = self
        
        self.selectedIndex = 1
        
        //        self.tabBarController?.tabBarItem.isEnabled = false
        //        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        //
        
        // tabBarController?.selectedIndex = 3
       
        
        
        
        //  print(self.viewControllers![2] as! UINavigationController)
        
        //        let navController = self.viewControllers![2] as! UINavigationController
        //
        //        print(navController)
        //
        //        let staticProfile = navController.topViewController as! SWRevealViewController
        
        
        
        //        staticProfile.profileInfo = profileInfo
        // print(profileInfo)
        
    }
    
    
    
    
    //    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    //        guard let viewcontrollers = viewControllers else {
    //            return
    //        }
    //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //
    //        // instantiate the view controller we want to show from storyboard
    //        // root view controller is tab bar controller
    //        // the selected tab is a navigation controller
    //        // then we push the new view controller to it
    //        if  let conversationVC = storyboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController,
    //            let tabBarController = self.window?.rootViewController as? UITabBarController,
    //            let navController = tabBarController.selectedViewController as? UINavigationController {
    //
    //            // we can modify variable of the new view controller using notification data
    //            // (eg: title of notification)
    //            // you can access custom data of the push notification by using userInfo property
    //            // response.notification.request.content.userInfo
    //            navController.pushViewController(conversationVC, animated: true)
    //        }
    //
    //
    //
    //        if let browseIndex = (tabBarController?.viewControllers?.filter { $0 is UINavigationController} as? [UINavigationController])?.firstIndex(where: { $0.viewControllers.first is MapViewController }) {
    //            tabBarController?.selectedIndex = browseIndex
    //        }
    //
    //
    //        for viewcontroller in viewcontrollers{
    //
    //
    //            if let menuitemcontroller = viewcontroller as? SearchViewController {
    //
    //
    //
    //            }
    //        }
    //    }
    //    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    //
    //        if  let conversationVC = storyboard!.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController,
    //            let tabBarController = self.window?.rootViewController as? UITabBarController,
    //            let navController = tabBarController.selectedViewController as? UINavigationController {
    //
    //            // we can modify variable of the new view controller using notification data
    //            // (eg: title of notification)
    //            // you can access custom data of the push notification by using userInfo property
    //            // response.notification.request.content.userInfo
    //            navController.pushViewController(conversationVC, animated: true)
    //        }
    //
    //
    //
    //        print((tabBarController.viewControllers?.filter { $0 is UINavigationController}) as Any)
    //
    //
    //        if let browseIndex = (tabBarController.viewControllers?.filter { $0 is UINavigationController} as? [UINavigationController])?.firstIndex(where: { $0.viewControllers.first is MapViewController }) {
    //            tabBarController.selectedIndex = browseIndex
    //        }
    //          return true
    ////        if viewController == tabBarController.viewControllers?[2] {
    ////            return false
    ////        } else {
    ////            return true
    ////        }
    //    }
    
    
    //    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    //        self.previousSelectedTabIndex = tabBarController.selectedIndex
    //    }
    
    //      override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    //
    //
    //        if self.selectedIndex != 3 {
    //            let yourView = self.viewControllers![self.selectedIndex] as! UINavigationController
    //            yourView.popToRootViewController(animated: false)
    //        }
    //        else {
    //
    //            self.tabBarController?.tabBar.isHidden = false
    //            NavigationController.NavigateToStaticProfile(self)
    //
    //
    ////            let viewControllers: [UIViewController] = self.navigationController!.viewControllers ;
    ////            for aViewController in viewControllers {
    ////                if(aViewController is StaticProfileViewController){
    ////
    ////                    self.navigationController!.popToViewController(aViewController, animated: true);
    ////                }
    ////            }
    //
    //        }
    //    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.previousSelectedTabIndex = tabBarController.selectedIndex
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item:
        UITabBarItem) {
        let vc = self.viewControllers![previousSelectedTabIndex] as! UINavigationController
        print(self.previousSelectedTabIndex)
        
        if self.previousSelectedTabIndex == 3{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vController = storyboard.instantiateViewController(withIdentifier: "StaticProfileViewController") as? StaticProfileViewController {
                if let vc1 = vc.viewControllers[0] as? SWRevealViewController {
                    vc1.navigationController?.popToRootViewController(animated: false)
                    vc1.setFront(vController, animated: false)
                }
            }
        }
        
        else if self.previousSelectedTabIndex == 1
        {
            if let vc1 = vc.viewControllers[0] as? ScanImageViewController {
                
                Utility.ManageActivityView(viewController: vc, action: Utility.UIActivityAction.ActionRemove)
                vc1.navigationController!.removeViewController(ScanImageViewController.self)
                
                vc.popToRootViewController(animated: false)
            }
        }
            
        else {
            
          
            Utility.ManageActivityView(viewController: vc, action: Utility.UIActivityAction.ActionRemove)

            vc.popToRootViewController(animated: false)
        }
        
    }
    
}
extension UINavigationController {
    
    func removeViewController(_ controller: UIViewController.Type) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.removeFromParent()
        }
    }
}

extension BottomTabbarViewController {
    
    func setupView() {
        
        tabBar.items![0].title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Discover", comment: "")
        tabBar.items![1].title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "scan", comment: "")
        tabBar.items![2].title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "search", comment: "")
        tabBar.items![3].title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "profile", comment: "")
        
        
    }
}
