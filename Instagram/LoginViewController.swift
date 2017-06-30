//
//  LoginViewController.swift
//  Instagram
//
//  Created by Gerardo Parra on 6/27/17.
//  Copyright © 2017 Gerardo Parra. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 5
        
        usernameField.delegate = self
        passwordField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIButton.animate(withDuration: 0.3) {
            var frame = self.signUpButton.frame
            if frame.origin.y == 614 {
                frame.origin.y -= 240
            }
            
            self.signUpButton.frame = frame
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIButton.animate(withDuration: 0.3) {
            var frame = self.signUpButton.frame
            if frame.origin.y == 374 {
                frame.origin.y += 240
            }
            
            self.signUpButton.frame = frame
        }
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: Error?) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription.capitalized, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            }
        }
    }

    @IBAction func onSignUp(_ sender: Any) {
        let newUser = PFUser()
        
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        newUser["portrait"] = Post.getPFFileFromImage(image: #imageLiteral(resourceName: "profile-pic"))
        newUser["about"] = "Tap photo and description to edit"
        
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if success {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription.capitalized, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            }
        }
    }
    
    @IBAction func didTapScreen(_ sender: Any) {
        self.view.endEditing(true)
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
