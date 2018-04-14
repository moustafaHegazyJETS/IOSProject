//
//  MovieNameView.swift
//  MoviePro
//
//  Created by Sayed Abdo on 4/7/18.
//  Copyright © 2018 Sayed Abdo. All rights reserved.
//

import UIKit

@IBDesignable class MovieNameView: UIView {

    @IBInspectable var cornerradius : CGFloat = 2
    @IBInspectable var shadowOffsetSetWidth : CGFloat = 0
    @IBInspectable var shadowOffsetSetHeight : CGFloat = 2
    @IBInspectable var shadowColor : UIColor =  UIColor.gray
    @IBInspectable var shadowOpacity : CGFloat = 0.5
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerradius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetSetWidth , height: shadowOffsetSetHeight)
        let shadowPath = UIBezierPath(roundedRect : bounds , cornerRadius : cornerradius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)
    }

}
