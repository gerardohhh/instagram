//
//  ExploreViewController.swift
//  Instagram
//
//  Created by Gerardo Parra on 6/28/17.
//  Copyright © 2017 Gerardo Parra. All rights reserved.
//

import UIKit
import Parse

class ExploreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        fetchPosts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreCell", for: indexPath) as! ExploreCell
        
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
    
    // Query database for posts
    func fetchPosts() {
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        query.includeKey("author")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        if let indexPath = collectionView.indexPath(for: cell) {
            let post = posts[indexPath.row]
            let detailViewController = segue.destination as! PostDetailsViewController
            detailViewController.post = post
        }
    }

}
