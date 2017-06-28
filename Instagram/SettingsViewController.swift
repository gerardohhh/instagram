//
//  SettingsViewController.swift
//  Instagram
//
//  Created by Gerardo Parra on 6/27/17.
//  Copyright © 2017 Gerardo Parra. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didLogOut(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("logoutNotification"), object: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
