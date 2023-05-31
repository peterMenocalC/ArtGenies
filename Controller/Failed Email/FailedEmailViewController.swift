//
//  FailedEmailViewController.swift
//  ArtGenies
//
//  Created by Abhay Bachche on 25/10/19.
//  Copyright © 2019 Abhay Bachche. All rights reserved.
//

import UIKit

class FailedEmailViewController: UIViewController {

    @IBOutlet var bgImg: UIImageView!
    @IBOutlet var validationFaileLbl: UILabel!
    
    
    @IBOutlet var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func SignIn_Tapped(_ sender: Any) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
