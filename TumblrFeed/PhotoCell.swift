//
//  PhotoCell.swift
//  TumblrFeed
//
//  Created by Claire Chen on 6/21/17.
//  Copyright © 2017 Claire Chen. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {
    
    @IBOutlet weak var pictureView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
