
import UIKit

class ReviewCell: UITableViewCell {
    
    
    @IBOutlet weak var ReviewPersonImg: UIImageView!
   
    @IBOutlet weak var PersonNameLabel: UILabel!
    
    @IBOutlet weak var reviewContentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
