//
//  ScanImageViewController.swift
//  ArtGenies
//
//  Created by Yash Tatiya on 29/06/19.
//  Copyright © 2019 CrestBit. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON
import Photos

class ScanImageViewController: UIViewController {
    
    private var imageView: UIImageView!
    @IBOutlet weak var statusLbl: UILabel!
    let viewModel = ViewModel()
    @IBOutlet weak var scanView: UIView!
    var captureSession = AVCaptureSession()
    var frontCamera,backCamera,currentCamrera: AVCaptureDevice?
    var boxView:UIView!
    let myButton: UIButton = UIButton()
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var crosshairView: CrosshairView? = nil
    let ciContext = CIContext(options: nil)
    var rect: CIRectangleFeature = CIRectangleFeature()
    var focusPoint:CGPoint!
    var ArtInfoDetail:ArtInfoDetails? = nil
    private var cropedImage: UIImage!
    
    //   private let originalImage = UIImage(named: "doc")
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        languageCode = UserDefault.getCountryCode()
        
        if crosshairView == nil {
            crosshairView = CrosshairView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            crosshairView?.backgroundColor = UIColor.clear
            self.view.addSubview(crosshairView!)
            
            self.view.addSubview(statusLbl)
            self.view.bringSubviewToFront(statusLbl)
            
        }
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch (authStatus){
            
        case .notDetermined:
            showAlert(title: "Unable to access the Camera", message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.")
        case .restricted:
            showAlert(title: "Unable to access the Camera", message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.")
        case .denied:
            showAlert(title: "Unable to access the Camera", message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.")
        case .authorized:
            print("authorised")
        }
    }
        
        func showAlert(title:String, message:String) {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
                // Take the user to Settings app to possibly change permission.
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            // Finished opening URL
                        })
                    } else {
                        // Fallback on earlier versions
                        UIApplication.shared.openURL(settingsUrl)
                    }
                }
            })
            alert.addAction(settingsAction)
            
            self.present(alert, animated: true, completion: nil)
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.statusLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "scanning", comment: "")
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        
        
    }
    
    func AddCustomMyLocationButton(){
        let button   = UIButton(type: UIButton.ButtonType.system) as UIButton
        button.frame = CGRect(x: self.view.frame.width - 60, y: AppDelegate.sharedInstance.height <= 800.0 ?  25 : 40, width: 40, height: 40)
        button.setBackgroundImage(UIImage(named: "qrcode.png"), for: UIControl.State())
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(ScanImageViewController.ScanButton_Tapped(_:)), for: UIControl.Event.touchUpInside)
        view.addSubview(button)
        button.bringSubviewToFront(view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startRunningCaptureSession()
        AddCustomMyLocationButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        captureSession.stopRunning()
       
    }
    @objc func ScanButton_Tapped(_ sender:UIButton!) {
         captureSession.stopRunning()
       self.navigationController?.popViewController(animated: true)
        
      //  NavigationController.NavigateToScanQRCode(self)
    }
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
    }
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        currentCamrera = backCamera
        
       
        
    }
    func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamrera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    
    func setupPreviewLayer() {
        
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(cameraPreviewLayer!)
        
        //        boxView = UIView(frame: self.view.frame)
        //        myButton.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        //        myButton.backgroundColor = UIColor.red
        //        myButton.layer.masksToBounds = true
        //        myButton.setTitle("press me", for: .normal)
        //        myButton.setTitleColor(UIColor.white, for: .normal)
        //        myButton.layer.cornerRadius = 20.0
        //        myButton.layer.position = CGPoint(x: self.view.frame.width/2, y:self.view.frame.height - 50)
        //
        //
        //        view.addSubview(boxView)
        //        view.addSubview(myButton)
        
    }
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
        if crosshairView == nil {
            crosshairView = CrosshairView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            crosshairView?.backgroundColor = UIColor.clear
            self.view.addSubview(crosshairView!)
            
            self.view.addSubview(statusLbl)
            self.view.bringSubviewToFront(statusLbl)
            
            // self.focusOut()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: {
            self.focusOut()
            let settings = AVCapturePhotoSettings()
            self.photoOutput?.capturePhoto(with: settings, delegate: self)
        })
    }
    
    func focusIn() {
        
        UIView.animate(withDuration: 2.0, animations: {() -> Void in
            
            //            do {
            //                try self.currentCamrera!.lockForConfiguration()
            //
            //self.statusLbl.text = "focusin"
            // self.focusPoint = CGPoint(x:500.0,y:500.0)
            //self.currentCamrera?.focusPointOfInterest = self.focusPoint
            //self.currentCamrera?.focusMode = .autoFocus
            self.crosshairView!.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            //self.currentCamrera!.unlockForConfiguration()
            
            //            } catch let error as NSError {
            //                print(error.localizedDescription)
            //            }
        }, completion: {(_ finished: Bool) -> Void in
            self.focusOut()
        })
    }
    
    func focusOut() {
        
        UIView.animate(withDuration: 3.0, animations: {() -> Void in
            
            //            do {
            //                try self.currentCamrera!.lockForConfiguration()
            //
            // self.focusPoint = CGPoint(x: 0.0,y:0.0)
            //self.currentCamrera?.focusPointOfInterest = self.focusPoint
            //self.statusLbl.text = "focusout"
            //self.currentCamrera?.focusMode = .autoFocus
            self.crosshairView!.transform = CGAffineTransform(scaleX: 1, y: 1)
           // self.currentCamrera?.unlockForConfiguration()
            
            //            } catch let error as NSError {
            //                print(error.localizedDescription)
            //            }
        }, completion: {(_ finished: Bool) -> Void in
            self.focusIn()
        })
    }
}

extension ScanImageViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        //DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
        if let dataImage = photo.fileDataRepresentation() {
            
            let originalImage = UIImage(data: dataImage)
            
            let imageData = originalImage!.jpegData(compressionQuality:0.0)
            
            let originalImage2 = UIImage(data: imageData!)
            
            let docImage = CIImage(image: originalImage2!)!
            
            
            if let detector = CIDetector(ofType: CIDetectorTypeRectangle,
                                         context: self.ciContext,
                                         options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]) {
                
                if let detect = detector.features(in: docImage).first  {
                    
                    self.statusLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "fetching_result", comment: "")
                    
                    self.rect = detect as! CIRectangleFeature
                    
                    var overlay = CIImage(color: CIColor(red: 0, green: 0, blue: 1, alpha: 0.5))
                    
                    overlay = overlay.cropped(to: docImage.extent)
                    overlay = overlay.applyingFilter("CIPerspectiveTransformWithExtent", parameters:
                        [kCIInputExtentKey : CIVector(cgRect: docImage.extent),
                         "inputTopLeft": CIVector(cgPoint:self.rect.topLeft),
                         "inputTopRight": CIVector(cgPoint:self.rect.topRight),
                         "inputBottomRight": CIVector(cgPoint:self.rect.bottomRight),
                         "inputBottomLeft": CIVector(cgPoint:self.rect.bottomLeft)
                        ])
                    let image = overlay.composited(over: docImage)
                    
                    let updatedImage = UIImage(ciImage: image, scale: originalImage!.scale, orientation: originalImage!.imageOrientation)
                    
                    let perspectiveCorrection = CIFilter(name: "CIPerspectiveCorrection")!
                    //  let docImage = CIImage(image: self.originalImage!)!
                    
                    perspectiveCorrection.setValue(CIVector(cgPoint:self.self.rect.topLeft),
                                                   forKey: "inputTopLeft")
                    perspectiveCorrection.setValue(CIVector(cgPoint:self.rect.topRight),
                                                   forKey: "inputTopRight")
                    perspectiveCorrection.setValue(CIVector(cgPoint:self.rect.bottomRight),
                                                   forKey: "inputBottomRight")
                    perspectiveCorrection.setValue(CIVector(cgPoint:self.rect.bottomLeft),
                                                   forKey: "inputBottomLeft")
                    perspectiveCorrection.setValue(docImage,
                                                   forKey: kCIInputImageKey)
                    
                    let outputImage = perspectiveCorrection.outputImage
                    
                    let updatedImage1 = UIImage(ciImage: outputImage!, scale: originalImage!.scale, orientation: originalImage!.imageOrientation)
                    
                    
                    self.cropedImage = updatedImage1.fixed()
//                    self.viewModel.savePhoto(self.cropedImage!.fixedOrientation().imageRotatedByDegrees(degrees: 180.0)) { (error) in
//                        if let error = error {
//                            print(error)
//                        }
//                    }
                    
                    if Reachability.isConnectedToNetwork() {
                        var userDisc = [String:Any]()
                        userDisc["user"] = [ID:UserDefault.getUserId()]
                        WebServices.sharedInstance.sendScanImage( self.cropedImage!.fixedOrientation().imageRotatedByDegrees(degrees: 180.0).jpegData(compressionQuality:0.0)!,userDisc, completionHandler: { (matching:JSON,statusCode:Int) -> Void in
                            
                            if statusCode == 200 {
                                
                                self.ArtInfoDetail = ArtInfoDetails(artinfojson: matching[DATA])
                                NavigationController.NavigateToArtInfoScan(self,true,self.ArtInfoDetail!)
                            }
                            else {
                                self.statusLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_result_found", comment: "")
                                
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: {
                                      self.focusOut()
                                    let settings = AVCapturePhotoSettings()
                                    self.photoOutput?.capturePhoto(with: settings, delegate: self)
                                })
//
                            }
                        })
                    }
                    else {
                        Utility.ShowAlert(title:LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_internet", comment: ""), message: "")
                    }
                } else {
                    self.statusLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "scanning", comment: "")
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                        let settings = AVCapturePhotoSettings()
                          self.focusOut()
                        self.photoOutput?.capturePhoto(with: settings, delegate: self)
                    })
                
                }
            }
            
        } else {
            
            self.statusLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_result_found", comment: "")
            print("some error here")
        }
    }
}


extension UIImage {
    func fixed() -> UIImage {
        let ciContext = CIContext(options: nil)
        
        let cgImg = ciContext.createCGImage(ciImage!, from: ciImage!.extent)
        let image = UIImage(cgImage: cgImg!, scale: scale, orientation: .left)
        
        return image
    }
}



extension UIImage {
    public func imageRotatedByDegrees(degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(self.cgImage!, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    public func fixedOrientation() -> UIImage {
        if imageOrientation == UIImage.Orientation.up {
            return self
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case UIImageOrientation.down, UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case UIImageOrientation.left, UIImageOrientation.leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi/2)
            break
        case UIImageOrientation.right, UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -CGFloat.pi/2)
            break
        case UIImageOrientation.up, UIImageOrientation.upMirrored:
            break
        }
        
        switch imageOrientation {
        case UIImageOrientation.upMirrored, UIImageOrientation.downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImageOrientation.leftMirrored, UIImageOrientation.rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImageOrientation.up, UIImageOrientation.down, UIImageOrientation.left, UIImageOrientation.right:
            break
        }
        
        let ctx: CGContext = CGContext(data: nil,
                                       width: Int(size.width),
                                       height: Int(size.height),
                                       bitsPerComponent: self.cgImage!.bitsPerComponent,
                                       bytesPerRow: 0,
                                       space: self.cgImage!.colorSpace!,
                                       bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case UIImageOrientation.left, UIImageOrientation.leftMirrored, UIImageOrientation.right, UIImageOrientation.rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        let cgImage: CGImage = ctx.makeImage()!
        
        return UIImage(cgImage: cgImage)
    }
}
