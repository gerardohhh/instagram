//
//  PostDetailsViewController.swift
//  Instagram
//
//  Created by Gerardo Parra on 6/28/17.
//  Copyright © 2017 Gerardo Parra. All rights reserved.
//

import UIKit
import Parse

class PostDetailsViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var post: PFObject? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Details"
        
        if let post = post {
            let user = post["author"] as! PFUser
            usernameLabel.text = user.username
            authorLabel.text = user.username
                
            captionLabel.text = (post["caption"] as! String)
            let likesCount = (post["likesCount"] as! NSNumber)
            likesLabel.text = "\(likesCount) likes"
            
            // Set profile image
            profileImage.layer.cornerRadius =  15
            if let profpic = user["portrait"] as? PFFile {
                profpic.getDataInBackground { (imageData: Data?, error: Error?) in
                    if error == nil {
                        let profImage = UIImage(data: imageData!)
                        self.profileImage.image = profImage
                        self.profileImage.clipsToBounds = true
                    }
                }
            }
            
            // Set post image
            let photo = post["media"] as! PFFile
            photo.getDataInBackground { (imageData: Data?, error: Error?) in
                if error == nil {
                    let image = UIImage(data: imageData!)
                    self.postImage.image = image
                }
            }
            
            // Set timestamp
            if let date = post.createdAt {
                let dateFormatter = DateFormatter()
                let timeFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                timeFormatter.dateStyle = .none
                timeFormatter.timeStyle = .short
                dateFormatter.locale = Locale(identifier: "en_US")
                let dateString = dateFormatter.string(from: date as Date)
                let timeString = timeFormatter.string(from: date as Date)
                timeLabel.text = timeString
                dateLabel.text = dateString
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
