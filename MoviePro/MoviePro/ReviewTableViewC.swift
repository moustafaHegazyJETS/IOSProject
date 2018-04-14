
import UIKit

class ReviewTableViewC: UITableViewController {
    
    var movieReviews : [MovieReviews] = [MovieReviews]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableViewAutomaticDimension

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movieReviews.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath as IndexPath) as! ReviewCell
        cell.PersonNameLabel.text = movieReviews[indexPath.row].PersonName
        cell.reviewContentLabel.text = movieReviews[indexPath.row].ReviewContent
        
        print(movieReviews[indexPath.row].ReviewContent)
        
        print("********")
        
        return cell
    }


}
