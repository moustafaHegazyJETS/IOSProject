
import UIKit
import WCLShineButton
import CoreData
import Alamofire
import SwiftyJSON

class DisplaySingleMovieView: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    
    
    @IBOutlet weak var SalmaView: UIView!
    //My vars
    var movieTitle : String = "";
    var movieImg : String = "";
    var movieReleaseDate : Int = 0;
    var movieLength : Int = 0;
    var movieRating : Int = 0;
    var movieOverView : String = "";
    var movieTrailers : [MovieTrailer] = [MovieTrailer]()
    var returnedMovieReviews = JSON()
    var singleMovieReviewsArray: [MovieReviews] = [MovieReviews]();
    var movieId : String = ""
    
    
    
    
    //Outlets
    
    
    @IBOutlet weak var mTitle: UILabel!
    @IBOutlet weak var mImage: UIImageView!
    @IBOutlet weak var mReleaseDate: UILabel!
    @IBOutlet weak var mLength: UILabel!
    @IBOutlet weak var mRate: UILabel!
    @IBOutlet weak var myTableV: UITableView!
    @IBOutlet weak var overviewContentLabel: UILabel!
    var favMovie : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableV.delegate = self
        myTableV.dataSource = self
        myTableV.estimatedRowHeight = 100
        myTableV.rowHeight = UITableViewAutomaticDimension
        
        var param1 = WCLShineParams()
        param1.bigShineColor = UIColor(rgb: (153,152,38))
        param1.smallShineColor = UIColor(rgb: (102,102,102))
        let bt1 = WCLShineButton(frame: .init(x: 170, y: 100, width: 30, height: 30), params: param1)
        
        
        
        // get movie name from core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
        let myPredicate = NSPredicate(format:"movieName == %@" , movieTitle)
        fetchRequest.predicate = myPredicate
        
        do{
            let count = try managedContext.count(for: fetchRequest)
            
            if count == 0{
                print("This movie isn't in core data")
                favMovie = false
                bt1.fillColor = UIColor(rgb: (153,152,38))
                bt1.color = UIColor(rgb: (170,170,170))
            }else{
                print("This movie in already in core data")
                favMovie = true
                bt1.fillColor = UIColor(rgb: (170,170,170))
                bt1.color = UIColor(rgb: (153,152,38))
            }

        }catch let error as NSError{
            print("Error while getting check movie from core data\n");
        }
        
        bt1.addTarget(self, action: #selector(favouriteBtnClicked), for: .touchUpInside)
//        view.addSubview(bt1)
        SalmaView.addSubview(bt1)
 
    }
    
    @objc func favouriteBtnClicked(){
        print("==> favourite btn clicked");
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if favMovie == true{
            
            //delete movie from core data
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
            let predicate = NSPredicate(format: "movieName == %@", movieTitle)
            fetchRequest.predicate = predicate
            
            let result = try? managedContext.fetch(fetchRequest)
            let resultData = result as! [Movie]
            
            for object in resultData {
                managedContext.delete(object)
            }
            
            do {
                try managedContext.save()
                print("Deleted!")
                favMovie = false
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            
        }else{
            //save movie name and image
            let entity = NSEntityDescription.entity(forEntityName:"Movie" , in: managedContext)
            let movie = NSManagedObject(entity:entity!,insertInto: managedContext)
            
            movie.setValue(movieTitle, forKey: "movieName")
            movie.setValue(movieImg, forKey: "movieImg")
            
            do{
                try managedContext.save()
                favMovie = true
                print("Saved")
            }catch let error as NSError{
                print("Error while saving movie title in core data :\(error)")
            }
            
        }
 
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        mTitle.text = movieTitle;
        mReleaseDate.text = String(movieReleaseDate)
        mRate.text = String(movieRating) + "/10"
        overviewContentLabel.text = movieOverView
        print("in DISPLAY => \(movieOverView)")
        let url = NSURL(string: movieImg);
        do{
            
            let img = try NSData(contentsOf: url! as URL)
            let myImage = UIImage(data: img! as Data)
            mImage.image = myImage
            
        }catch
        {
            print("error")
        }
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

            return movieTrailers.count


    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "TrailerCell", for: indexPath as IndexPath)
            cell.textLabel?.text = movieTrailers[indexPath.row].trailerName
            cell.imageView?.image = UIImage(named:"play.png")
            
            return cell


    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.myTableV
        {
            let youtubeId = movieTrailers[indexPath.row].trailerKey
            var youtubeUrl = NSURL(string:"youtube://\(youtubeId)")!
            if UIApplication.shared.canOpenURL(youtubeUrl as URL){
                UIApplication.shared.openURL(youtubeUrl as URL)
            } else{
                youtubeUrl = NSURL(string:"https://www.youtube.com/watch?v=\(youtubeId)")!
                UIApplication.shared.openURL(youtubeUrl as URL)
            }
        }
    }
    
    @IBAction func GetReviewsBtn(_ sender: Any) {
        
        self.getMovieReviews(movieId: movieId , completion: {
            
            let displayReviews:ReviewTableViewC = self.storyboard?.instantiateViewController(withIdentifier: "movieReviews") as! ReviewTableViewC
            
            displayReviews.movieReviews = self.singleMovieReviewsArray
            self.singleMovieReviewsArray.removeAll()
            
            
            self.navigationController?.pushViewController(displayReviews, animated: true)
        })
    }
  
    
    func getMovieReviews(movieId : String , completion:@escaping () -> ()) {
        
        
        Alamofire.request("https://api.themoviedb.org/3/movie/\(movieId)/reviews?api_key=7b2ed60f32a69f88bcf82491fafec7a0&language=en-US&page=1").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.value!)
                self.returnedMovieReviews = swiftyJsonVar["results"]
                
                print(swiftyJsonVar["results"][0]["author"])
               
                if(!self.returnedMovieReviews.isEmpty){
                    print("YES THERE IS REVIEW")
                    for i in 0...(self.returnedMovieReviews.count)-1{
                        
                        let singleReview : MovieReviews = MovieReviews()
                        
                        var dic = self.returnedMovieReviews[i]
                        
                        print("*************")
                        print(i)
                        print(dic["content"].stringValue)
                        print("*************")
                        
                        singleReview.PersonName = dic["author"].stringValue
                        singleReview.ReviewContent = dic["content"].stringValue
                        
                        self.singleMovieReviewsArray.insert(singleReview, at: i)
                        print("YA RAAAAAAB ::: \(singleReview.PersonName)")
                        
                        
                        for element in self.singleMovieReviewsArray
                        {
                            print("BELOW R \(element.PersonName)")
                        }
                        
                        
                    }
                    
                    
                    
                }
                

                
                
            }
            completion()
        }
        
    }


}
