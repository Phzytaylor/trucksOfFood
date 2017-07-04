//
//  ImageViewGradientExtention.swift
//  trucksOfFood
//
//  Created by Taylor Simpson on 6/27/17.
//  Copyright © 2017 Taylor Simpson. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
    func addBlackGradientLayer(frame: CGRect){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = [UIColor.clear.cgColor,UIColor.darkGray.cgColor]
        gradient.locations = [0.0, 2.5]
        self.layer.addSublayer(gradient)
    }
}
