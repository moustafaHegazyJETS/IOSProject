
import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON
import Dropdowns
import Photos
import Foundation

private let reuseIdentifier = "Cell"



class MainCollectionViewController: UICollectionViewController {
    
    
    
    @IBOutlet var collectView: UICollectionView!
    
    var arrRes = JSON();
    var returnedMovieTrailers = JSON()
    var singleMovieT: [MovieTrailer] = [MovieTrailer]();
  
    override func viewWillAppear(_ animated: Bool) {

        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //style collection view cell
        
        let itemSize = UIScreen.main.bounds.width/2
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width:itemSize , height:itemSize+40)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectView?.collectionViewLayout = layout
        
        //drop down
        var check : String = "popular"
        
        let items = ["Popular" , "Now Playing", "Top Rated" , "Upcoming"] // popular is the default
        let titleView = TitleView(navigationController: navigationController!, title: "Popular", items: items)
         titleView?.action = { [weak self] index in
            
            print("select \(index)")
            
            switch index {
            case 0 :
                check="popular"
            case 1 :
                check="now_playing"
            case 2 :
                check="top_rated"
            case 3 :
                check="upcoming"
           
            default:
                check="popular"
            }
            
            if self?.isConnectedToInternet() == true{
                print("YES THERE IS INTERNET ")
                self?.alamofireRequest(ChecckVal: check)
            }else{
                print("NO THERE ISN'T")
                self?.alert(message: "No Internet Connection")
            }
            
           

            
        }
    
        
        
        
        navigationItem.titleView = titleView
        
        //---------------------------------
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        if self.isConnectedToInternet() == true{
            print("YES THERE IS INTERNET ")
            alamofireRequest(ChecckVal: check)
        }else{
            print("NO THERE ISN'T")
            alert(message: "No Internet Connection")
        }
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return  arrRes.count-1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        

        if self.arrRes.count > 0 {


            var dic = arrRes[indexPath.row]

            var poster:String = dic["poster_path"].stringValue

            var check = poster.isEmpty

            if !check
                {



                var urlString:String = "http://image.tmdb.org/t/p/w185\(poster)";
                let url = NSURL(string: String(describing:urlString) )
                
                    cell.movieImageV.sd_setImage(with: url as URL?)

        
            }
            
        
        }
        
        
        return cell
    }



    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
        let displayMovie:DisplaySingleMovieView = self.storyboard?.instantiateViewController(withIdentifier: "movieDetails") as! DisplaySingleMovieView

        var singleObject = arrRes[indexPath.row]
        
        

        displayMovie.movieId = singleObject["id"].stringValue
        displayMovie.movieTitle = singleObject["title"].stringValue
        displayMovie.movieReleaseDate = singleObject["release_date"].intValue
        displayMovie.movieRating = singleObject["vote_average"].intValue
        displayMovie.movieOverView = singleObject["overview"].stringValue
        displayMovie.movieImg = "http://image.tmdb.org/t/p/w185\(singleObject["poster_path"].stringValue)"
        
        //get movie trailers
        getMovieTrailers(movieId : singleObject["id"].stringValue , completion: {
            displayMovie.movieTrailers = self.singleMovieT;
            self.singleMovieT.removeAll()
            
            for element in displayMovie.movieTrailers
            {
                print("ABOVE \(element.trailerName)")
            }
            
            print("movies trailers length is \(displayMovie.movieTrailers.count)")
            
            self.navigationController?.pushViewController(displayMovie, animated: true)

        });

        
    }
    
    func getMovieTrailers(movieId : String , completion:@escaping () -> ()) {

        print(movieId)
         Alamofire.request("https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=7b2ed60f32a69f88bcf82491fafec7a0&language=en-US").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.value!)
                self.returnedMovieTrailers = swiftyJsonVar["results"]
                
                print(swiftyJsonVar["results"][0]["key"])
                
                print(self.returnedMovieTrailers[0]["key"])
               if(!self.returnedMovieTrailers.isEmpty){
                    print("YES THERE IS KEY")
                    for i in 0...(self.returnedMovieTrailers.count)-1{
                        
                        let singleMov : MovieTrailer = MovieTrailer()
                        
                        var dic = self.returnedMovieTrailers[i]
                        
                        print("*************")
                        print(i)
                        print(dic["name"].stringValue)
                        print("*************")
                        
                        singleMov.trailerName = dic["name"].stringValue
                        singleMov.trailerKey = dic["key"].stringValue
                        
                        self.singleMovieT.insert(singleMov, at: i)
                        print("YA RAAAAAAB ::: \(singleMov.trailerName)")
                        
                        
                        for element in self.singleMovieT
                        {
                            print("BELOW \(element.trailerName)")
                        }
                        
                        
                    }
                    
                    
                
                }
                
                print("SINGLE LENGTH IS \(self.singleMovieT.count) ")
                

            }
        completion()
    }
    
    }
    
    

    
    @IBAction func sortMovies(_ sender: Any) {
        
        
        
        
    }

    
    func alamofireRequest(ChecckVal: String )
    {
        
        Alamofire.request("https://api.themoviedb.org/3/movie/\(ChecckVal)?api_key=7b2ed60f32a69f88bcf82491fafec7a0&language=en-US&page=1").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.value!)
                //                print(swiftyJsonVar)
                
                print(swiftyJsonVar["results"][1]["poster_path"])
                self.arrRes=swiftyJsonVar["results"]
                
                
                for i in 0...(self.arrRes.count)-1{
                    
                    var dic = self.arrRes[i]
                    
                    let poster = dic["poster_path"].string
                    
                    print("*************")
                    print(i)
                    print(poster)
                    print("*************")
                }

                //if self.arrRes.count > 0 {
                    self.collectionView?.reloadData();
//                }else
//                {
//                    print("aaaaaaaaaaaaaaaaaa")
//                    let alert = UIAlertController(title: "No Network", message: "Please Chjeck your network connection !!", preferredStyle: UIAlertControllerStyle.alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                        switch action.style{
//                        case .default:
//                            print("default")
//
//                        case .cancel:
//                            print("cancel")
//
//                        case .destructive:
//                            print("destructive")
//
//
//                        }}))
//                    self.present(alert, animated: true, completion: nil)
//
//
//
//                }

            }
                    }
        
        
        
        
    }

    
    func isConnectedToInternet() -> Bool{
        return NetworkReachabilityManager()!.isReachable
    }
    
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alertController.addAction(OKAction)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

