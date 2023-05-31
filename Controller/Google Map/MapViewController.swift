
//
//  MapViewController.swift
//  Mitya
//
//  Created by Adam Szeremeta on 25.04.2015.
//  Copyright (c) 2015 RST IT. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import MaterialShowcase

class MyTapGesture: UITapGestureRecognizer {
    var gallerymap:GalleryMaps!
    var exhibitionymap:ExhibitionsMaps!
}
class POIItem: NSObject {
    
    var position: CLLocationCoordinate2D
    
    var galleryMaps:GalleryMaps!
    var exhibitionsMaps:ExhibitionsMaps!
    
    
    init(position: CLLocationCoordinate2D,galleryMaps:GalleryMaps?,exhibitionsMaps:ExhibitionsMaps?) {
        self.position = position
        self.galleryMaps = galleryMaps
        self.exhibitionsMaps = exhibitionsMaps
    }
}

class MapViewController :  UIViewController, GMSMapViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var titleLblText: UILabel!
    @IBOutlet var lblClickHere: UILabel!
    
    var mapView: GMSMapView!
    var currentUserMarker:GMSMarker!
    private var infoWindow = MapInfoWindow()
    var centerMapCoordinate:CLLocationCoordinate2D!
    let searchbutton   = UIButton(type: UIButton.ButtonType.system) as UIButton
    var mapTarget:CLLocationCoordinate2D!
    var sequence = MaterialShowcaseSequence()
    var usersMarkers:[GMSMarker] = [GMSMarker]()
    var exhibitionMarkers:[GMSMarker] = [GMSMarker]()
    fileprivate var locationMarker : GMSMarker? = GMSMarker()
    var tapGesture = UITapGestureRecognizer()
    var GalleryListModels =  GalleryListModel()
    var autoCompleteArray = [String]()
    var finalArray = [String]()
    var radarRadius:CGFloat!
    
    var mapDetails:MapDetails? = nil
    var GalleryMapsArray = [GalleryMaps]()
    var ExhibitionsArray = [ExhibitionsMaps]()
    var exhibitionsDetails:ExhibitionsDetails? = nil
    @IBOutlet var previewBtn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
          self.addGoogleMapsToView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let showcase1 = MaterialShowcase()
        showcase1.setTargetView(barButtonItem: previewBtn)
        showcase1.primaryText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "see_all", comment: "")
        showcase1.secondaryText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "all_galleries_exhibitions", comment: "")
        showcase1.isTapRecognizerForTargetView = true
        showcase1.targetTintColor = UIColor.blue
        showcase1.targetHolderRadius = 44
        showcase1.targetHolderColor = UIColor.clear
        showcase1.primaryTextColor = UIColor.white
        showcase1.secondaryTextColor = UIColor.white
        showcase1.primaryTextSize = 30
        showcase1.secondaryTextSize = 20
        showcase1.delegate = self
        sequence.temp(showcase1).setKey(key: "eve").start()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
        if CLLocationManager.locationServicesEnabled()
        {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined,.restricted, .denied:
                
                let refreshAlert = UIAlertController(title: NSLocalizedString("title_location_settings_alert", comment: "Location Alert"), message: NSLocalizedString("miitya_location_settings_alert", comment: "Location Alert Message"), preferredStyle: UIAlertController.Style.alert)
                refreshAlert.addAction(UIAlertAction(title: NSLocalizedString("Open_location_settings_alert", comment: "Open settings"), style: .default, handler: { (action: UIAlertAction!) in
                    let settingsUrl = URL(string: UIApplication.openSettingsURLString)
                    if let url = settingsUrl {
                        UIApplication.shared.openURL(url)
                    }
                }))
                
                refreshAlert.addAction(UIAlertAction(title: NSLocalizedString("Later_location_settings_alert", comment: "Later"), style: .default, handler: { (action: UIAlertAction!) in
                    
                }))
                
                present(refreshAlert, animated: true, completion: nil)
                LocationManager.sharedInstance.startUpdatingLocation()
            case .authorizedAlways,.authorizedWhenInUse:
                
                LocationManager.sharedInstance.startUpdatingLocation()
                self.addCurrentUserMarker()
                
                if runningdisplay == true {
                    
                    var paramDisc = [String:Any]()
                    paramDisc[LAT] = LocationManager.sharedInstance.latitude
                    paramDisc[LONG] = LocationManager.sharedInstance.longitude
                    
                    
                    getCurrentRunningExhibition(parameters: paramDisc)
                }
                
            }
            
        }
//        else
//        {
//            let refreshAlert = UIAlertController(title: NSLocalizedString("title_location_settings_alert", comment: "Location Alert"), message: NSLocalizedString("location_settings_alert", comment: "Location Alert Message"), preferredStyle: UIAlertController.Style.alert)
//
//            refreshAlert.addAction(UIAlertAction(title: NSLocalizedString("Open_location_settings_alert", comment: "Open settings"), style: .default, handler: { (action: UIAlertAction!) in
//                let settingsUrl = URL(string: UIApplication.openSettingsURLString)
//                if let url = settingsUrl {
//                    UIApplication.shared.openURL(url)
//                }
//            }))
//
//            refreshAlert.addAction(UIAlertAction(title: NSLocalizedString("Later_location_settings_alert", comment: "Later"), style: .default, handler: { (action: UIAlertAction!) in
//
//            }))
//
//            present(refreshAlert, animated: true, completion: nil)
//        }
        
        LocationManager.sharedInstance.startUpdatingLocation()
        self.titleLblText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "galleryexhibitionsmap", comment: "")
        
        languageCode = UserDefault.getCountryCode()
        // DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
      
        self.addCurrentUserMarker()
        
       // self.AddCustomMyLocationButton()
        self.AddCustomGetRadiusButton()
        // })
        
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        infoWindow.removeFromSuperview()
        
    }
    
    @IBAction func fotoFever(_ sender: Any) {
        NavigationController.NavigateToGalleryDetails( self, "5db4769179d2902f47043274",EXHIBITION_DETAILS)
    }
    @IBAction func Preview_Tapped(_ sender: Any) {
        
        NavigationController.NavigateToPreview(self)
    }
    
    // MARK: LocationManagerProtocol
    
    func locationManagerDidUpdateLocation(_ location: CLLocation) {
        
        print(location.coordinate)
        
        self.currentUserMarker.position = location.coordinate
        if self.currentUserMarker.map == nil {
            
            self.currentUserMarker.map = self.mapView
        }
    }
    
    
    // MARK: MapView
    
    func addGoogleMapsToView() {
        
        var camera:GMSCameraPosition!
      
        
        if  UserDefault.getUserLatitude()  == nil  && UserDefault.getUserLongitude() == nil{
            camera = GMSCameraPosition.camera(withLatitude: 48.1391200, longitude:11.5641800, zoom:6)
           // camera = GMSCameraPosition.camera(withLatitude: 0, longitude:0, zoom:0)
            self.mapView = GMSMapView.map(withFrame: self.view.frame, camera:camera)
            self.mapView.delegate = self
            self.mapView.settings.myLocationButton = true
            self.mapView.isMyLocationEnabled = true
            self.view.insertSubview(self.mapView, at: 0)
            
        } else {
            
            camera = GMSCameraPosition.camera(withLatitude: UserDefault.getUserLatitude()!, longitude:UserDefault.getUserLongitude()!, zoom:10)
            self.mapView = GMSMapView.map(withFrame: self.view.frame, camera:camera)
            self.mapView.delegate = self
            self.mapView.settings.myLocationButton = true
            self.mapView.isMyLocationEnabled = true
            //self.mapView.padding = UIEdgeInsets(top: 0, left: 0,bottom: self.view.frame.size.height / 3, right: 0);
            self.view.insertSubview(self.mapView, at: 0)
            
            
            if runningdisplay == false {
            
            var paramDisc = [String:Any]()
            paramDisc[LAT] = LocationManager.sharedInstance.latitude
            paramDisc[LONG] = LocationManager.sharedInstance.longitude
            paramDisc[RADIUS] = "5000"


            getGalleriesAndexhibitions(parameters: paramDisc)
            }
        }
        
    }
    
    func addCurrentUserMarker() {
        
        
        if UserDefault.getUserLatitude() == nil  && UserDefault.getUserLongitude() == nil{
            
        } else {
            
            self.currentUserMarker = GMSMarker(position: CLLocationCoordinate2DMake( UserDefault.getUserLatitude()!,UserDefault.getUserLongitude()!))
            self.currentUserMarker.icon = UIImage(named: "me")
            self.currentUserMarker.groundAnchor = CGPoint(x: 0.5, y: 0.8)
            self.currentUserMarker.isTappable = false
            self.currentUserMarker.zIndex = 1
            self.currentUserMarker.map?.clear()
            
        }
        
        
        // self.currentUserMarker = GMSMarker(position:CLLocationCoordinate2DMake(kCameraLatitude, kCameraLongitude))
        
    }
    
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        return UIView()
    }
    
    
    // MARK: Needed to create the custom info window
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoWindow.removeFromSuperview()
    }
    
    // MARK: Needed to create the custom info window (this is optional)
    func sizeForOffset(view: UIView) -> CGFloat {
        return  65.0
    }
    
    // MARK: Needed to create the custom info window (this is optional)
    func loadNiB(poiItem:GalleryMaps) -> MapInfoWindow{
        let infoWindow = MapInfoWindow.instanceFromNib() as! MapInfoWindow
        infoWindow.setupCellGallery(gallery: poiItem)
        let tapGesture = MyTapGesture.init(target: self, action: #selector(MapViewController.markerTapped(_:)))
        tapGesture.gallerymap = poiItem
        tapGesture.numberOfTapsRequired = 1
        infoWindow.addGestureRecognizer(tapGesture)
        infoWindow.isUserInteractionEnabled = true
        return infoWindow
    }
    
    func loadNiB(poiItem:ExhibitionsMaps) -> MapInfoWindow{
        let infoWindow = MapInfoWindow.instanceFromNib() as! MapInfoWindow
        infoWindow.setupCellExhibition(exhibition: poiItem)
        let tapGesture = MyTapGesture.init(target: self, action: #selector(MapViewController.markerTapped(_:)))
        tapGesture.exhibitionymap = poiItem
        tapGesture.numberOfTapsRequired = 1
        infoWindow.addGestureRecognizer(tapGesture)
        infoWindow.isUserInteractionEnabled = true
        return infoWindow
    }
    
    
    @objc func markerTapped(_ sender: MyTapGesture) {
        
        if sender.exhibitionymap == nil {
            
            NavigationController.NavigateToGalleryDetails(self,sender.gallerymap._id!,GALLERY_DETAILS)
        }
        else {
            
            NavigationController.NavigateToGalleryDetails(self,sender.exhibitionymap._id,EXHIBITION_DETAILS)
            
        }
        
        
        
        
        
        
        
        //         NavigationController.NavigateToGalleryAndExhibition(self)
        //         infoWindow.removeFromSuperview()
        
    }
    
    // MARK: - Private
    /// Randomly generates cluster items within some extent of the camera and adds them to the
    /// cluster manager.
    //    private func generateClusterItems() {
    //
    //        let extent = 0.2
    //        for index in 1...kClusterItemCount {
    //            let lat = kCameraLatitude + extent * randomScale()
    //            let lng = kCameraLongitude + extent * randomScale()
    //            let name = "Item \(index)"
    //            let item = POIItem(position: CLLocationCoordinate2DMake(lat, lng), name: name)
    //            clusterManager.add(item)
    //        }
    //    }
    
    
    private func generateClusterItems() {
        
        var clusterItems = [POIItem]()
        
        if usersMarkers.count > 0 {
            
            for index in 0..<usersMarkers.count {
                
                let marker = usersMarkers[index]
                
                let lat = marker.position.latitude
                
                let lng = marker.position.longitude
                
                let item = POIItem(position: CLLocationCoordinate2DMake(lat, lng), galleryMaps: marker.userData as? GalleryMaps, exhibitionsMaps:nil)
                clusterItems.append(item)
            }
            
        }
        
        
        
        
        
        //        for index in 1...
        //        {
        //            let lat = kCameraLatitude + extent * randomScale()
        //            let lng = kCameraLongitude + extent * randomScale()
        //            let name = "Item \(index)"
        //            let item = POIItem(position: CLLocationCoordinate2DMake(lat, lng), name: name)
        //            clusterManager.add(item)
        //        }
    }
    
    
    
   
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if let poiItem = marker.userData as? GalleryMaps {
            locationMarker = marker
            infoWindow.removeFromSuperview()
            infoWindow = loadNiB(poiItem: poiItem)
            guard let location = locationMarker?.position else {
                print("locationMarker is nil")
                return false
            }
            infoWindow.center = mapView.projection.point(for: location)
            infoWindow.center.y = infoWindow.center.y - sizeForOffset(view: infoWindow)
            self.view.addSubview(infoWindow)
            
        } else if let poiItem = marker.userData as? ExhibitionsMaps {
            locationMarker = marker
            infoWindow.removeFromSuperview()
            infoWindow = loadNiB(poiItem: poiItem)
            guard let location = locationMarker?.position else {
                print("locationMarker is nil")
                return false
            }
            infoWindow.center = mapView.projection.point(for: location)
            infoWindow.center.y = infoWindow.center.y - sizeForOffset(view: infoWindow)
            self.view.addSubview(infoWindow)
        }
            
        else  {
            NSLog("Did tap a normal marker")
        }
        
        // Needed to create the custom info window
        
        
        return false
    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        view.addSubview(searchbutton)
        searchbutton.bringSubviewToFront(view)
        
    }
    
    // MARK: Needed to create the custom info window
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if (locationMarker != nil){
            guard let location = locationMarker?.position else {
                print("locationMarker is nil")
                return
            }
            infoWindow.center = mapView.projection.point(for: location)
            infoWindow.center.y = infoWindow.center.y - sizeForOffset(view: infoWindow)
        }
        
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        
        
        
        
        
    }
    // MARK: GMSMapView Delegate Methods
    
    
    // MARK: Custom Center User Location Button
    
    func AddCustomMyLocationButton(){
        let button   = UIButton(type: UIButton.ButtonType.system) as UIButton
        button.frame = CGRect(x: self.view.frame.width - 60, y: AppDelegate.sharedInstance.height <= 800.0 ?  95 : 125, width: 55, height: 55)
        //  button.setTitle("Abhay", for: .normal)
        button.setBackgroundImage(UIImage(named: "location"), for: UIControl.State())
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(MapViewController.myLocationButtonAction(_:)), for: UIControl.Event.touchUpInside)
        view.addSubview(button)
        button.bringSubviewToFront(view)
    }
    func AddCustomGetRadiusButton(){
        
        // let button   = UIButton(type: UIButton.ButtonType.system) as UIButton
        searchbutton.frame = CGRect(x: self.view.frame.width/2 - 160, y: AppDelegate.sharedInstance.height <= 800.0 ?  70 : 100, width: 320, height: 40)
        searchbutton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "searchgallery", comment: ""), for: .normal)
        searchbutton.titleLabel?.font = UIFont(name:"Times New Roman", size: 13.5)
        searchbutton.backgroundColor = UIColor.white
        //  searchbutton.setBackgroundImage(UIImage(named: "location"), for: UIControl.State())
        searchbutton.imageView?.contentMode = .scaleAspectFit
        searchbutton.addTarget(self, action: #selector(MapViewController.searchGallery(_:)), for: UIControl.Event.touchUpInside)
        
    }
    
    func addFotoFever() {
        self.lblClickHere.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "click_here", comment: "")
    }
    
    @objc func myLocationButtonAction(_ sender:UIButton!)
    {
         if  UserDefault.getUserLatitude()  == nil  && UserDefault.getUserLongitude() == nil{
            
        } else {
            
            
            self.mapView.animate(toLocation: CLLocationCoordinate2D(latitude:UserDefault.getUserLatitude()! , longitude:UserDefault.getUserLongitude()!))
            self.mapView.animate(toZoom: 17.0)
            self.currentUserMarker.map?.clear()
            self.mapTarget = nil
            
        }
    }
    
    @objc func searchGallery(_ sender:UIButton!)
    {
        var paramDisc = [String:Any]()
        paramDisc[LONG] = centerMapCoordinate.longitude
        paramDisc[LAT] = centerMapCoordinate.latitude
        paramDisc[RADIUS] = self.mapView.getRadius(centerCoordinate: centerMapCoordinate)
        getGalleriesAndexhibitions(parameters: paramDisc)
        
    }
}


extension MapViewController {
    
    
    func getCurrentRunningExhibition(parameters: [String:Any]) {
        
        if Reachability.isConnectedToNetwork() {
            
            WebServices.sharedInstance.getCurrentRunningExhibition(parameters, completionHandler: { (gallandexhibidetails:JSON,statusCode:Int) -> Void in
                
                if statusCode == 200 {
                    
                       self.exhibitionsDetails = ExhibitionsDetails(exhibitionjson: gallandexhibidetails[DATA])
                    
                    Utility.ShowAlertWithoupTimer(preferredStyle: .alert, title: self.exhibitionsDetails!.name, message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "nearfound", comment: "") + self.exhibitionsDetails!.name, buttons: [LocalizationSystem.sharedInstance.localizedStringForKey(key: "no", comment: ""),LocalizationSystem.sharedInstance.localizedStringForKey(key: "yes", comment: "")], completionClosure: { (index) -> Void in
                        
                        if index == 0 {
                            
                            var paramDisc = [String:Any]()
                            paramDisc[LAT] = LocationManager.sharedInstance.latitude
                            paramDisc[LONG] = LocationManager.sharedInstance.longitude
                            paramDisc[RADIUS] = "5000"
                            
                            self.getGalleriesAndexhibitions(parameters: paramDisc)
                            
                        }
                        else {
                            NavigationController.NavigateToGalleryDetails(self,self.exhibitionsDetails!._id,EXHIBITION_DETAILS)
            
                        }
                        
                        runningdisplay = false
                    
                })
                }
                else  if statusCode == 404  {   self.searchGallery(nil)}
            })
        }
        else {
            Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_internet", comment: ""), message: "")
        }
        
    }
    
    func getGalleriesAndexhibitions(parameters: [String:Any]) {
        
        if Reachability.isConnectedToNetwork() {
            
            Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionAdd)
            
            WebServices.sharedInstance.getGalleriesAndexhibitions(parameters, completionHandler: { (gallandexhibidetails:JSON,statusCode:Int) -> Void in
                
                Utility.ManageActivityView(viewController: self, action: Utility.UIActivityAction.ActionRemove)
                
                if statusCode == 200 {
                    
                    DispatchQueue.main.async {
                        self.mapDetails = MapDetails.init(mapdetailsjson: gallandexhibidetails[DATA])
                        self.GalleryMapsArray = self.mapDetails!.galleryMap
                        self.ExhibitionsArray = self.mapDetails!.exhibitionsMap
                        
                        self.setup()
                    }
                }
                else  if statusCode == 404 {
                    
                    Utility.ShowPopAlert(title: NSLocalizedString(LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_exhibition_gallery_found", comment: ""), comment: ""), message: "",timeinseconds: 2)
                }
                else  if statusCode == 500 {
                    
                }
                self.searchbutton.removeFromSuperview()
                
            })
        }
        else {
            Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_internet", comment: ""), message: "")
        }
        
    }
    
    func setup()
    {
        
        for profile in self.GalleryMapsArray {
            
            let long = profile.location.coordinates[0]
            let lat = profile.location.coordinates[1]
            let location = CLLocation(latitude: lat, longitude: long)
            let marker = GMSMarker(position: location.coordinate)
            marker.zIndex = 4
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.9)
            marker.isTappable = true
            marker.map = self.mapView
            marker.userData = profile
            self.usersMarkers.append(marker)
        }
        
        for exhibition in self.ExhibitionsArray {
            
            let long = exhibition.locations[0].location.coordinates[0]
            let lat = exhibition.locations[0].location.coordinates[1]
            let location = CLLocation(latitude: lat, longitude: long)
            let marker = GMSMarker(position: location.coordinate)
            marker.zIndex = 4
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.9)
            marker.isTappable = true
            marker.map = self.mapView
            marker.userData = exhibition
            self.exhibitionMarkers.append(marker)
        }
        
        
        // self.setupClusterManager()
        
    }
    
    func visibleRadius() -> Double {
        // Get CLLocation for top-left of map
        let topLeft = CGPoint.zero
        let topLeftCoordinate = mapView.projection.coordinate(for: topLeft)
        let topLeftLocation = CLLocation(latitude: topLeftCoordinate.latitude,
                                         longitude: topLeftCoordinate.longitude)
        
        // Get CLLocation for bottom-right of map
        let bottomRight = CGPoint(x: mapView.bounds.width, y: mapView.bounds.height)
        let bottomRightCoordinate = mapView.projection.coordinate(for: bottomRight)
        let bottomRightLocation = CLLocation(latitude: bottomRightCoordinate.latitude,
                                             longitude: bottomRightCoordinate.longitude)
        
        // Radius is half of distance from top-left to bottom-right
        return Double(bottomRightLocation.distance(from: topLeftLocation) / 2)
    }
}

extension GMSMapView {
    func getCenterCoordinate() -> CLLocationCoordinate2D {
        let centerPoint = self.center
        let centerCoordinate = self.projection.coordinate(for: centerPoint)
        return centerCoordinate
    }
    
    func getTopCenterCoordinate() -> CLLocationCoordinate2D {
        // to get coordinate from CGPoint of your map
        let topCenterCoor = self.convert(CGPoint(x: self.frame.size.width, y: 0), from: self)
        let point = self.projection.coordinate(for: topCenterCoor)
        return point
    }
    
    func getRadius(centerCoordinate:CLLocationCoordinate2D) -> CLLocationDistance {
        //        let centerCoordinate = getCenterCoordinate()
        let centerLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        print("latitude : \(centerCoordinate.latitude), longitude: \(centerCoordinate.longitude)")
        let topCenterCoordinate = self.getTopCenterCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        let radius = CLLocationDistance(centerLocation.distance(from: topCenterLocation))
        print("\((round(radius) + 1000000))")
        return (round(radius) + 1000000)
    }
}

extension MapViewController: MaterialShowcaseDelegate {
    func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
        sequence.showCaseWillDismis()
    }
}


