//
//  PhotoViewController.swift
//  TumblrFeed
//
//  Created by Claire Chen on 6/21/17.
//  Copyright © 2017 Claire Chen. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotoViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    var posts: [[String: Any]] = []
    var isMoreDataLoading = false
    var offset = 0
    
    @IBOutlet weak var tableView: UITableView!
    //var photoURL : String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let session = URLSession(configuration: .default,    delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(dataDictionary)
                
                // Get dictionary from response key
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                
                // Store returned array in posts
                self.posts = responseDictionary["posts"] as! [[String:Any]]
                
                // Reload the table view
                self.tableView.reloadData()
            }
        }
        task.resume()
        
        //pull to refresh
        let refreshControl = UIRefreshControl()
        //bind the action to the refresh 
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (!isMoreDataLoading){
           // isMoreDataLoading = true
            
            // Calculate how much we've scrolled
            let scrollHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollHeight - tableView.bounds.size.height
            
            // When to request
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging){
                isMoreDataLoading = true
                loadMoreData()
            }
        }
    }
    
    
    func loadMoreData() {
        
        offset += 25
        let offsetString = String(offset)
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV&offset=" + offsetString)!
        let session = URLSession(configuration: .default,    delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            
            self.isMoreDataLoading = false
            
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
               
                
                // Get dictionary from response key
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                
                // Store returned array in posts
                self.posts += responseDictionary["posts"] as! [[String:Any]]
                
                // Reload the table view
                self.tableView.reloadData()
            }
        }
        task.resume()

    
    }
    
    
    
    func refreshControlAction( _ refreshControl: UIRefreshControl){
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let session = URLSession(configuration: .default,    delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(dataDictionary)
                
                // Get dictionary from response key
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                
                // Store returned array in posts
                self.posts = responseDictionary["posts"] as! [[String:Any]]
                
                // Reload the table view
                self.tableView.reloadData()
                
                refreshControl.endRefreshing()
            }
        }
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let post = posts[indexPath.row]
        if let photos = post["photos"] as? [[String:Any]]{
            //photo is not nil we can use it!!!!!!!!
            let photo = photos[0]
            let originalSize = photo["original_size"] as! [String: Any]
            let urlString = originalSize["url"] as! String
            let url = URL(string: urlString)
            //self.photoURL = urlString
            cell.pictureView.af_setImage(withURL: url!)
            
            
        }
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let vc = segue.destination as! PhotoDetailsViewController
         let cell = sender as! UITableViewCell
         let indexPath = tableView.indexPath(for: cell)!
         let post = posts[indexPath.row]
         vc.post = post        
        
    }
   

}
