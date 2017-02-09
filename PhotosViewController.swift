//
//  PhotosViewController.swift
//  
//
//  Created by Ryan Liszewski on 2/1/17.
//
//

import UIKit
import AFNetworking
import MBProgressHUD

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage!
    var offset: Int!
    
    var posts: [NSDictionary] = []
    
    var isMoreDataLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.isToolbarHidden = true
        let refreshControl = UIRefreshControl()
        
        offset = 0;
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 240
       
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV&?offset=\(offset)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        // This is where you will store the returned array of posts in your posts property
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        
                        self.tableView.reloadData()
                    }
                }
        });
        
        task.resume()
 
        
        // Do any additional setup after loading the view.
    }

    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
      offset = 0
      self.tumbrlApiCall()
      refreshControl.endRefreshing()
        
    }
    
    
    func tumbrlApiCall(){
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV&offset=\(offset)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        // This is where you will store the returned array of posts in your posts property
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        
                        //self.posts.append(responseFieldDictionary)
                        
                        //self.tableView.reloadData()
                    }
                }
        });
        
        task.resume()
    }
    
    
    func loadMoreData(){
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV&offset=\(offset)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        // This is where you will store the returned array of posts in your posts property
                        //self.posts += responseFieldDictionary["posts"] as! [NSDictionary]
                        
                        self.posts.append(responseFieldDictionary)
                        
                        //self.posts = self.posts + responseFieldDictionary["posts"] as! [NSDictionary]
                        self.tableView.reloadData()
                    }
                }
        });
        isMoreDataLoading = false
        task.resume()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell

        let post = posts[indexPath.section]
        
        //print(indexPath.row)
        
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            
            if let imageUrl = URL(string: imageUrlString!){
                cell.imagePostView.setImageWith(imageUrl)
            }
        }
        return cell 
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        if(!isMoreDataLoading){
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging){
                isMoreDataLoading = true
                offset = 1000 + offset
                loadMoreData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let post = posts[section]
        let date = post["date"]
        
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
        
        
        
        
        
        let textLabel = UILabel(frame: CGRect(x:200, y:0, width: 120, height: 30))
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.text = date as! String?
        
        // Set the avatar
        profileView.setImageWith(NSURL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")! as URL)
        headerView.addSubview(profileView)
        headerView.addSubview(textLabel)
        
        // Add a UILabel for the date here
        // Use the section number to get the right URL
        // let label = ...
        
       
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }



    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let tumblrPost: NSDictionary
        
        let cell = sender as! UITableViewCell
        let indexpath = tableView.indexPath(for: cell)
        tumblrPost = posts[(indexpath?.section)!]
        
        let photoDetailViewController = segue.destination as! PhotoDetailViewController
        

        photoDetailViewController.tumblrPost = tumblrPost
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
