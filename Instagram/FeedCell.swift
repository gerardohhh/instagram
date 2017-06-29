//
//  FeedCell.swift
//  Instagram
//
//  Created by Gerardo Parra on 6/28/17.
//  Copyright © 2017 Gerardo Parra. All rights reserved.
//

import UIKit
import Parse

class FeedCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var secondUserLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    var post: PFObject? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        likeImage.layer.cornerRadius = 12.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didLikePost(_ sender: Any) {
        var likesText = likesLabel.text ?? "0 likes"
        var likesAmount = Int(String(likesText.characters.dropLast(6)))!
        likesAmount += 1
        likesLabel.text = "\(likesAmount) likes"
        post?["likesCount"] = likesAmount
        if likesAmount % 2 != 0 && likesAmount != 0 {
            likeImage.backgroundColor = UIColor.red
        } else {
            likeImage.backgroundColor = UIColor.white
        }
        post?.saveInBackground(block: { (success: Bool, error: Error?) in
            // TODO: add alerts
        })
    }
}
