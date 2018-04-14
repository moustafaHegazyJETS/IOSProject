//
//  myLaunchScreenViewController.swift
//  MoviePro
//
//  Created by Sayed Abdo on 4/8/18.
//  Copyright © 2018 Sayed Abdo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class myLaunchScreenViewController: UIViewController {
    
    
    var timer = Timer()
    //
    var activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 200, y: 450, width: 60, height: 60), type: NVActivityIndicatorType.ballScaleMultiple, color: NVActivityIndicatorView.DEFAULT_COLOR , padding: NVActivityIndicatorView.DEFAULT_PADDING)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        activityIndicator.center = self.view.center
        
        
        self.view.addSubview(activityIndicator)
 
        activityIndicator.startAnimating()
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.getToMainScreen), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    @objc func getToMainScreen(){
        
        timer.invalidate()

        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MainV")
        activityIndicator.stopAnimating()
        self.present(nextVC! , animated: true, completion: nil)

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
