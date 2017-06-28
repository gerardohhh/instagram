//
//  FeedViewController.swift
//  Instagram
//
//  Created by Gerardo Parra on 6/27/17.
//  Copyright © 2017 Gerardo Parra. All rights reserved.
//

import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [PFObject] = []
    
    // Initialize a UIRefreshControl
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize navigation bar
        let logo = UIImage(named: "logo.png")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = logo
        self.navigationItem.titleView = imageView
        
        // Set up refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        fetchPosts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Return amount of tableView rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    // Setup tableView cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        let post = posts[indexPath.row]
        
        // Set text data
        cell.captionLabel.text = (post["caption"] as! String)
        let likesCount = (post["likesCount"] as! NSNumber)
        cell.likesLabel.text = "\(likesCount) likes"
        let user = post["author"] as? PFUser
        cell.usernameLabel.text = user?.username
        cell.secondUserLabel.text = user?.username
        
        // Set profile image
        cell.profileImage.layer.cornerRadius =  15
        if let profpic = user?["portrait"] as? PFFile {
            profpic.getDataInBackground { (imageData: Data?, error: Error?) in
                if error == nil {
                    let profImage = UIImage(data: imageData!)
                    cell.profileImage.image = profImage
                }
            }
        }
        
        // Set post image
        let photo = post["media"] as! PFFile
        photo.getDataInBackground { (imageData: Data?, error: Error?) in
            if error == nil {
                let image = UIImage(data: imageData!)
                cell.photoImageView.image = image
            }
        }
        
        // Set timestamp
        if let date = post.createdAt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: "en_US")
            let dateString = dateFormatter.string(from: date as Date)
            cell.timeLabel.text = dateString
        }
        
        return cell
    }
    
    // Query database for posts
    func fetchPosts() {
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        query.includeKey("author")
        query.findObjectsInBackground { (loadedPosts: [PFObject]?, error:Error?) in
            if error == nil {
                self.posts = loadedPosts!
                self.tableView.reloadData()
            } else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription.capitalized, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            }
        }
        
        tableView.reloadData()
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchPosts()
        // Tell the refreshControl to stop spinning
        refreshControl.endRefreshing()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let post = posts[indexPath.row]
            let detailViewController = segue.destination as! PostDetailsViewController
            detailViewController.post = post
        }
    }

}
