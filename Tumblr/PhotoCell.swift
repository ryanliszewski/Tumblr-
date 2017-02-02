//
//  PhotoCell.swift
//  Tumblr
//
//  Created by Ryan Liszewski on 2/1/17.
//  Copyright © 2017 Smiley. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell{

    
    @IBOutlet weak var photoCell: UIView!
    @IBOutlet weak var imagePostView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
