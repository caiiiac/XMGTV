//
//  CarouselViewModel.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/7/13.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class CarouselViewModel {
    lazy var carousels : [CarouselModel] = [CarouselModel]()
    
    func loadCarouselData(_ complection : @escaping () -> ()) {
        NetworkTools.requestData(.get, URLString: "http://qf.56.com/home/v4/getBanners.ios", finishedCallback: { (result : Any) in
            // 1.转成字典
            guard let resultDict = result as? [String : Any] else { return }
            
            // 2.根据message取出数据
            guard let msgDict = resultDict["message"] as? [String : Any] else { return }
            
            // 3.根据banners取出数据
            guard let banners = msgDict["banners"] as? [[String : Any]] else { return }
            
            // 4.转成模型对象
            for dict in banners {
                self.carousels.append(CarouselModel(dict: dict))
            }
            
            // 5.回调
            complection()
        })
    }
}
