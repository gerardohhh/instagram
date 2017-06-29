//
//  NewPostViewController.swift
//  Instagram
//
//  Created by Gerardo Parra on 6/27/17.
//  Copyright © 2017 Gerardo Parra. All rights reserved.
//

import UIKit
import Parse

class NewPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var newPostImage: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var captionText: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    
    var textHasBeenEdited = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.captionText.delegate = self
        
        captionText.text = "Write a caption..."
        captionText.textColor = UIColor.lightGray
        
        newPostImage.clipsToBounds = true
        
        shareButton.layer.cornerRadius = 5
    }

    @IBAction func didTapImageButton(_ sender: Any) {
        // Instantiate UIImagePickerController
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            action in
            vc.sourceType = .camera
            self.present(vc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
            action in
            vc.sourceType = .photoLibrary
            self.present(vc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc(textViewDidBeginEditing:) func textViewDidBeginEditing(_ captionText: UITextView) {
        textHasBeenEdited = true
        if captionText.textColor == UIColor.lightGray {
            captionText.text = nil
            captionText.textColor = UIColor.black
        }
    }
    
    @objc(textViewDidEndEditing:) func textViewDidEndEditing(_ captionText: UITextView) {
        if captionText.text.isEmpty {
            textHasBeenEdited = false
            captionText.text = "Write a caption..."
            captionText.textColor = UIColor.lightGray
        }
    }
    
    // Select image
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        imageButton.isHidden = true
        newPostImage.image = editedImage
        
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
    
    // Hide keyboard
    @IBAction func didTapScreen(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    // Cancel post
    @IBAction func didCancelPost(_ sender: Any) {
        // Hide keyboard
        self.view.endEditing(true)
        
        // Clear post data
        newPostImage.image = nil
        imageButton.isHidden = false
        
        // Send home
        NotificationCenter.default.post(name: NSNotification.Name("sentPostNotification"), object: nil)
    }
    
    // Send post
    @IBAction func didSendPost(_ sender: Any) {
        if textHasBeenEdited == false {
            captionText.text = ""
        }
        // Check for attached image
        if newPostImage.image != nil {
            // Resize image
            let newSize: CGSize = CGSize(width: 750.0, height: 750.0)
            let resizedImage = resize(image: newPostImage.image!, newSize: newSize)
            
            // Post image
            Post.postUserImage(image: resizedImage, withCaption: captionText.text, withCompletion: { (success: Bool, error: Error?) in
                if success {
                    // Clear post data, hide keyboard
                    self.view.endEditing(true)
                    self.newPostImage.image = nil
                    self.imageButton.isHidden = false
                } else {
                    // Alert error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription.capitalized, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                    }
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true)
                }
            } )
        } else {
            // Ask user to select image
            let alertController = UIAlertController(title: "Please select an image", message: "An image is required for posting", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Try Again", style: .cancel) { (action) in
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
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
