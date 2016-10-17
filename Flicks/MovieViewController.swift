//
//  MovieViewController.swift
//  Flicks
//
//  Created by Claudiu Andrei on 10/15/16.
//  Copyright © 2016 Claudiu Andrei. All rights reserved.
//

import UIKit
import SwiftyJSON
import AFNetworking

class MovieViewController: UIViewController {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    // Prefix
    let imageURLPrefix = "https://image.tmdb.org/t/p"
    
    // Setup the data
    var data: JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the content mode
        movieImageView.contentMode = .scaleAspectFill
        
        // Setup image
        if let imagePath = data?["poster_path"].string {
            let imageURL = URL(string: "\(imageURLPrefix)/w500/\(imagePath)")
            movieImageView.setImageWith(imageURL!)
        }
    
        // Setup title
        if let title = data?["title"].string {
            movieTitleLabel.text = title
        }
        
        // Set description
        if let description = data?["overview"].string {
            movieDescriptionLabel.text = description
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
