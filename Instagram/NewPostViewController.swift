//
//  NewPostViewController.swift
//  Instagram
//
//  Created by Gerardo Parra on 6/27/17.
//  Copyright © 2017 Gerardo Parra. All rights reserved.
//

import UIKit
import Parse

class NewPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var newPostImage: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var newPostCaption: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newPostCaption.delegate = self
    }

    @IBAction func didTapImageButton(_ sender: Any) {
        // Instantiate UIImagePickerController
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            vc.sourceType = .camera
        } else {
            vc.sourceType = .photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // Select image
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageButton.isHidden = true
        newPostImage.image = originalImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    // Resize image
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let zero: CGPoint = CGPoint(x: 0, y: 0)
        let resizeImageView = UIImageView(frame: CGRect(origin: zero, size: newSize))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func clearAndHome() {
        // Clear post data
        newPostImage.image = nil
        imageButton.isHidden = false
        
        // Send home
        NotificationCenter.default.post(name: NSNotification.Name("sentPostNotification"), object: nil)
    }
    
    // Cancel post
    @IBAction func didCancelPost(_ sender: Any) {
        clearAndHome()
    }
    
    // Send post
    @IBAction func didSendPost(_ sender: Any) {
        let newSize: CGSize = CGSize(width: 1000.0, height: 1000.0)
        let resizedImage = resize(image: newPostImage.image!, newSize: newSize)
        Post.postUserImage(image: resizedImage, withCaption: newPostCaption.text, withCompletion: { (success: Bool, error: Error?) in
            if success {
                self.clearAndHome()
            } else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription.capitalized, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            }
        }
    ) }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
