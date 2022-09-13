//
//  ViewController.swift
//  Flix Assignment
//
//  Created by Gabby Santiago on 9/5/22.
//

import UIKit
import AlamofireImage

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Outlet foro the table view for scrolling
    @IBOutlet weak var tableView: UITableView!
    
    //Keeps the movies obtained from the API
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Just add this for now
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        
        //The network request
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data
                 
                    //Moves the data to the movies array in string form
                    self.movies = dataDictionary["results"] as! [[String:Any]]
                 
                    //reloads data for each row
                    self.tableView.reloadData()

             }
        }
        task.resume()
        //End network request
    }//End did load function
    
    
    //Returns number of rows to scroll through in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Recycles off screen cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        //Grabs values from the movies array to be displayed
        let movie = movies[indexPath.row]
        let title = movie["title"]
        let synopsis = movie["overview"] as! String
        
        //Displays them
        cell.titleLabel.text = title as? String
        cell.synLabel.text = synopsis
        
        //builds URL from image website and poster path
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        //sets poster with new URL
        cell.posterView.af.setImage(withURL: posterUrl!)
        
        return cell
    }
    
    //Prepares the details page when clicked
    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        
        print("Loading details...")
        
        //Finding the selected movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for:cell)!
        let movie = movies[indexPath.row]
        
        //Pass movie to the details view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        
        //Takes they gray out of the cell you clicked on when you come back to movies
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    

}

