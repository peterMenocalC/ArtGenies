////
////  YoutubeVideoController.swift
////  ArtGenies
////
////  Created by Abhay Bachche on 14/09/19.
////  Copyright © 2019 Abhay Bachche. All rights reserved.
////
//
//import UIKit
//import YouTubePlayer
////import YoutubePlayer_in_WKWebView
//
//class YoutubeVideoController: UIViewController {
//
//    @IBOutlet var notFoundLbl: UILabel!
//
//    @IBOutlet weak var playerView: YouTubePlayerView!
//    var videoUrl:String!
//
//    @IBAction func BackBtn_Tapped(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        playerView.backgroundColor = Utility.hexStringToUIColor(hex: "#222222")
//
//        if videoUrl == "" {
//
//            notFoundLbl.isHidden = false
//            notFoundLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "video_unavaliable", comment: "")
//
//        }
//        else {
//            let myVideoURL = NSURL(string: videoUrl)
//            playerView.loadVideoURL(myVideoURL! as URL)
//        }
//    }
//
//
//    /*
//     // MARK: - Navigation
//
//     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//     // Get the new view controller using segue.destination.
//     // Pass the selected object to the new view controller.
//     }
//     */
//
//}
