
import UIKit
import CoreData
import SDWebImage
import Alamofire



class FavouriteMoviesCollectionV: UICollectionViewController {

    @IBOutlet var collectView: UICollectionView!
    
    var data = [Movie]();
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("$$$$$$ In Favourite Movie View $$$$$$$")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            let movies = result as! [Movie]
            data = movies;
            self.collectView.reloadData()
            
            for singleMovie in movies {
                print(singleMovie.movieName)
            }
            
            
        }catch let err as NSError {
            print(err.debugDescription)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("tesrrrrr")
        
        let itemSize = (UIScreen.main.bounds.width/3) - 10
        let layout = UICollectionViewFlowLayout()
        let cell = UICollectionViewCell()
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        layout.itemSize = CGSize(width:itemSize , height:itemSize+40)
        layout.minimumInteritemSpacing = 2.5
        layout.minimumLineSpacing = 5
        
        
        
        collectView?.collectionViewLayout = layout

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

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
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return data.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favouriteCell", for: indexPath) as! collectionViewFavouriteCell
        
        cell.favouriteMovieName.text = data[indexPath.row].movieName
        
        let urlString:String = data[indexPath.row].movieImg!;
        
        let url = NSURL(string: String(describing:urlString))
        
        let s:String = data[indexPath.row].movieImg!
        
        if !s.isEmpty
        {
            
            let img = try NSData(contentsOf: url! as URL)
            let myImage = UIImage(data: img! as Data)
            cell.FavouriteMovieImg.image = myImage
            
            
        }

    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
