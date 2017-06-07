//
//  KingfisherExtension.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/6/7.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(_ URLString : String?, _ placeHolderName : String? = nil) {
        guard let URLString = URLString else {
            return
        }
        
        guard let url = URL(string: URLString) else {
            return
        }
        
        guard let placeHolderName = placeHolderName else {
            kf.setImage(with: url)
            return
        }
        
        kf.setImage(with: url, placeholder : UIImage(named: placeHolderName))
    }
}
