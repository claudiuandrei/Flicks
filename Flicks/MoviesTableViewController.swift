//
//  MoviesTableViewController.swift
//  Flicks
//
//  Created by Claudiu Andrei on 10/15/16.
//  Copyright © 2016 Claudiu Andrei. All rights reserved.
//

import UIKit
import SwiftyJSON
import AFNetworking

class MoviesTableViewController: UITableViewController {
    
    // Setup the number of movies
    var movies: [JSON] = []
    var isLoading: Bool = false
    
    var nextPage: Int = 1
    var complete: Bool = false
    
    // API
    let APIKey = "aae64ae6183535ac23b5ddf3f3b62bf9"
    let APIURLPrefix = "https://api.themoviedb.org/3"
    let imageURLPrefix = "https://image.tmdb.org/t/p"
    
    @IBOutlet weak var networkError: UIView!
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        
        // Reset the state
        movies = []
        nextPage = 1
        complete = false
        
        // Next state
        getNextNowPlaying()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Play the current page
        getNextNowPlaying()
        
        // Monitor the reachability
        monitorReachability()
        
        // Load the task
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // When loading we need to show an extra cell
        if isLoading {
            return movies.count + 1
        }
        
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row >= movies.count {
            return 44
        }
        
        return 128
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // If we have extra rows, show them as search (We only add one)
        if indexPath.row >= movies.count {
            return tableView.dequeueReusableCell(withIdentifier: "movieLoadingCell", for: indexPath)
        }
        
        // Load the country cell template
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieImageCell", for: indexPath) as! MovieTableViewCell
        
        // Setup the data in the cell
        cell.setViewData(data: movies[indexPath.row])
        
        // Done for country cells
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Compute if we should load next
        let offset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let shouldLoadNext = (maxOffset - offset) <= self.tableView.rowHeight && !self.isLoading && !self.complete

        // If we have next, we need to load it
        if shouldLoadNext {
            getNextNowPlaying()
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let movieDetailsView = segue.destination as! MovieViewController
        var indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
        
        // Set the view data
        movieDetailsView.data = movies[(indexPath?.row)!]
    }
    
    // Request data from the API
    func getNextNowPlaying() {
        
        // No work to do if complete
        if complete || isLoading {
            return
        }
        
        // We are loading data now
        isLoading = true
        
        self.tableView.reloadData()
        
        // Load the next now playing
        let request = URLRequest(url: URL(string: "\(APIURLPrefix)/movie/now_playing?api_key=\(APIKey)&page=\(nextPage)")!)
        
        // Send the request
        URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            // Load the response
            let response = JSON(data: data!)
            
            // Setup the movies
            self.movies += response["results"].arrayValue as [JSON]
            
            // Setup next page
            self.nextPage += 1
            
            // Check if we are done
            self.complete = response["page"].int == response["total_pages"].int
            
            // Done loading
            self.isLoading = false
            
            // Refresh the view
            DispatchQueue.main.async{
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }).resume()
    }
    
    // Monitor if the app is reachable
    func monitorReachability() {
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange {
            (status: AFNetworkReachabilityStatus) -> Void in
            
            switch status {
            case .notReachable, .unknown:
                self.networkError.isHidden = false
                self.networkError.frame.size.height = 22
            case .reachableViaWiFi, .reachableViaWWAN:
                self.networkError.isHidden = true
                self.networkError.frame.size.height = 0
            }
            
            // Reload data to show correct view
            self.tableView?.reloadData()
        }
        AFNetworkReachabilityManager.shared().startMonitoring()
    }
}
