//
//  PhotoDetailViewController.swift
//  Tumblr
//
//  Created by Ryan Liszewski on 2/8/17.
//  Copyright © 2017 Smiley. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    
    var tumblrPost: NSDictionary!
    
    @IBOutlet weak var photoDetailImageView: UIImageView!
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        let photos = tumblrPost.value(forKeyPath: "photos") as? [NSDictionary]
        
        
        let imageUrlString = photos?[0].value(forKeyPath: "original_size.url") as? String
        
        let imageURL = URL(string: imageUrlString!)
        
       photoDetailImageView.setImageWith(imageURL!)

        // Do any additional setup after loading the view.
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
