//
//  MovieTableViewCell.swift
//  Flicks
//
//  Created by Claudiu Andrei on 10/15/16.
//  Copyright © 2016 Claudiu Andrei. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftyJSON

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    // Prefix
    let imageURLPrefix = "https://image.tmdb.org/t/p"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setViewData(data: JSON) {
        
        // Initialization code
        // Setup image
        if let imagePath = data["poster_path"].string {
            let imageURL = URL(string: "\(imageURLPrefix)/w185/\(imagePath)")
            movieImageView.contentMode = .scaleAspectFill
            movieImageView.layer.cornerRadius = movieImageView.frame.size.height / 2
            movieImageView.clipsToBounds = true;
            movieImageView.setImageWith(imageURL!)
        }
        
        // Set title
        if let title = data["title"].string {
            movieTitleLabel.text = title
        }
        
        // Set description
        if let description = data["overview"].string {
            movieDescriptionLabel.text = description
        }
    }

}
