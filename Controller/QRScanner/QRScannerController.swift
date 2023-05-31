//
//  QRScannerController.swift
//  QRCodeReader
//
//  Created by Simon Ng on 13/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerController: UIViewController {
    
    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var found:Bool! = false
    
   
    let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // DispatchQueue.main.async {
        
            // Get the back-facing camera for capturing videos
            let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
            
            guard let captureDevice = deviceDiscoverySession.devices.first else {
                print("Failed to get the camera device")
                return
            }
            
            do {
                // Get an instance of the AVCaptureDeviceInput class using the previous device object.
                let input = try AVCaptureDeviceInput(device: captureDevice)
                
                // Set the input device on the capture session.
                
                if self.captureSession.inputs.isEmpty {
                    self.captureSession.addInput(input)
                }
                
                
                
                // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
                
                let captureMetadataOutput = AVCaptureMetadataOutput()
                if self.captureSession.outputs.isEmpty {
                    self.captureSession.addOutput(captureMetadataOutput)
                }
                DispatchQueue.main.async {
                    
                    
                    if captureMetadataOutput.metadataObjectTypes.isEmpty {
                        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                        captureMetadataOutput.metadataObjectTypes = self.supportedCodeTypes
                        
                    }
                }
                
                
                // Set delegate and use the default dispatch queue to execute the call back
                
                //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
                
            } catch {
                // If any error occurs, simply print it out and don't continue any more.
                print(error)
                return
            }
            self.AddCustomMyLocationButton()
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            self.videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.videoPreviewLayer?.frame = self.view.layer.bounds
            self.view.layer.addSublayer(self.videoPreviewLayer!)
         self.qrCodeFrameView = UIView()
//        if let qrCodeFrameView = self.qrCodeFrameView {
//            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
//            qrCodeFrameView.layer.borderWidth = 2
//            self.view.addSubview(qrCodeFrameView)
//            self.view.bringSubviewToFront(qrCodeFrameView)
//        }
            // Start video capture.
            self.captureSession.startRunning()
            
            // Move the message label and top bar to the front
            
            // Initialize QR Code Frame to highlight the QR code
        
            self.AddCustomMyLocationButton()
        
       // }
    }
  
    override func viewWillAppear(_ animated: Bool) {
        
        captureSession.startRunning()
    }
    override func viewDidDisappear(_ animated: Bool) {
        captureSession.stopRunning()
    }
    override func viewWillDisappear(_ animated: Bool) {

    captureSession.stopRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper methods
    
    //    func launchApp(decodedURL: String) {
    //
    //        if presentedViewController != nil {
    //            return
    //        }
    //
    //        let alertPrompt = UIAlertController(title: "Open App", message: "You're going to open \(decodedURL)", preferredStyle: .actionSheet)
    //        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { (action) -> Void in
    //
    //            if let url = URL(string: decodedURL) {
    //                if UIApplication.shared.canOpenURL(url) {
    //                    UIApplication.shared.open(url)
    //                }
    //            }
    //        })
    //
    //        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
    //
    //        alertPrompt.addAction(confirmAction)
    //        alertPrompt.addAction(cancelAction)
    //
    //        present(alertPrompt, animated: true, completion: nil)
    //    }
    
}

extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {
    
    func AddCustomMyLocationButton(){
        let button   = UIButton(type: UIButton.ButtonType.system) as UIButton
        button.frame = CGRect(x: self.view.frame.width - 60, y: AppDelegate.sharedInstance.height <= 800.0 ?  25 : 40, width: 50, height: 40)
        
        let scanimg = UIImage.init(named: "scan.png")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(scanimg, for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(QRScannerController.ScanButton_Tapped(_:)), for: UIControl.Event.touchUpInside )
        
        
        view.addSubview(button)
        view.bringSubviewToFront(button)
    }
    @objc func ScanButton_Tapped(_ sender:UIButton!) {
        captureSession.stopRunning()
        
      NavigationController.navigateToScanImage(self)
        
//        captureMetadataOutput.r
        
        
        
        
       // self.navigationController?.popViewController(animated: true)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
          captureSession.stopRunning()
        // Check if the metadataObjects array is not nil and it contains at least one object.
        //        if metadataObjects.count == 0 {
        //            qrCodeFrameView?.frame = CGRect.zero
        //
        //            print("Abhaysing Bachche")
        //
        //            return
        //        }
        
        
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if self.found == false {
            
            if supportedCodeTypes.contains(metadataObj.type) {
                // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
                let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
                qrCodeFrameView?.frame = barCodeObject!.bounds
                
                if metadataObj.stringValue != nil {
                    
                    
                    self.found = true
                    NavigationController.NavigateToArtInfo(self,metadataObj.stringValue!,SCAN)
                  
                    //  captureSession.removeInput(input)
                    
                }
            }
        }
    }
    
}
