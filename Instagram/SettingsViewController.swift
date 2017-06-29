//
//  SettingsViewController.swift
//  Instagram
//
//  Created by Gerardo Parra on 6/27/17.
//  Copyright © 2017 Gerardo Parra. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var aboutLabel: UITextField!
    
    let user = PFUser.current()
    var posts: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.profileImage.layer.cornerRadius = 50
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.aboutLabel.delegate = self
        
        self.title = user?.username
        usernameLabel.text = user?.username
        let about = user?["about"] as? String
        aboutLabel.text = about ?? "..."
        if let profpic = user?["portrait"] as? PFFile {
            profpic.getDataInBackground { (imageData: Data?, error: Error?) in
                if error == nil {
                    let profImage = UIImage(data: imageData!)
                    self.profileImage.image = profImage
                }
            }
        }
        
        fetchPosts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Log user out
    @IBAction func didLogOut(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("logoutNotification"), object: nil)
    }
    
    @IBAction func didTapIcon(_ sender: Any) {
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
    
    // Empty text
    func textFieldDidBeginEditing(_ textField: UITextField) {
        aboutLabel.text = nil
    }
    
    // Save bio
    func textFieldDidEndEditing(_ textField: UITextField) {
        if aboutLabel.text == "" {
            aboutLabel.text = "..."
        }
        user?["about"] = aboutLabel.text
        user?.saveInBackground(block: { (success: Bool, error: Error?) in
            if error != nil {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription.capitalized, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            }
        })
    }
    
    // Hide keyboard on return 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        aboutLabel.resignFirstResponder()
        return true
    }
    
    // Select image
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        profileImage.image = editedImage
        profileImage.clipsToBounds = true
        
        let imageFile = Post.getPFFileFromImage(image: editedImage)
        user?["portrait"] = imageFile
        
        user?.saveInBackground(block: { (success: Bool, error: Error?) in
            if error != nil {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription.capitalized, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            }
        })
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    // Query database for posts
    func fetchPosts() {
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        query.includeKey("author")
        query.whereKey("author", equalTo: user!)
        query.findObjectsInBackground { (loadedPosts: [PFObject]?, error:Error?) in
            if error == nil {
                self.posts = loadedPosts!
                self.collectionView.reloadData()
            } else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription.capitalized, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            }
        }
        
        collectionView.reloadData()
    }
    
    // Return amount of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    // Set up photo cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ExploreCell
        
        let post = posts[indexPath.item]
        
        // Set image
        let photo = post["media"] as! PFFile
        photo.getDataInBackground { (imageData: Data?, error: Error?) in
            if error == nil {
                let image = UIImage(data: imageData!)
                cell.exploreCellImage.image = image
            }
        }
        
        return cell
    }
    
    // Set up details segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        if let indexPath = collectionView.indexPath(for: cell) {
            let post = posts[indexPath.row]
            let detailViewController = segue.destination as! PostDetailsViewController
            detailViewController.post = post
        }
    }

}
