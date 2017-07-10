//
//  RankViewController.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/5/31.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit


class RankViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let pageRect = CGRect(x: 0, y: 20, width: kScreenW, height: kScreenH - 20)
        let titles = ["明星榜", "富豪榜", "人气榜", "周星榜"]
        let style = SANTitleStyle()
        style.normalColor = UIColor(r: 255, g: 255, b: 255)
        style.isScrollEnable = false
        style.isShowBottomLine = true
        
        var childVcs = [UIViewController]()
        for i in 0..<titles.count {
            let vc : SubrankViewController = i == 3 ? WeekrankViewController() : NormalRankViewController()
            vc.currentIndex = i
            childVcs.append(vc)
        }
        
        let pageView = SANPageView(frame: pageRect, titles: titles, style: style, childVcs: childVcs, parentVc: self)
        
        view.addSubview(pageView)
    }
    
}



