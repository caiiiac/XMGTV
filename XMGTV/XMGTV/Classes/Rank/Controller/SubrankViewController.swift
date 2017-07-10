//
//  SubrankViewController.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/7/10.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class SubrankViewController: UIViewController {

    
    fileprivate var typeName : String = ""
    
    var currentIndex : Int = 0 {
        didSet {
            switch currentIndex {
            case 0:
                typeName = "rankStar"
            case 1:
                typeName = "rankWealth"
            case 2:
                typeName = "rankPopularity"
            case 3:
                typeName = "rankAll"
            default:
                print("错误类型")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

extension SubrankViewController {
    
    func setupSubrankUI(_ titles : [String]) {
    
        let pageRect = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - 64 - 44)
        let titles = titles
        let style = SANTitleStyle()
        style.normalColor = UIColor(r: 0, g: 0, b: 0)
        style.isScrollEnable = false
        style.titleHeight = 35
        style.titleBgColor = .white
        
        
        var childVcs = [DetailRankViewController]()
        for i in 0..<titles.count {
            let rankType = RankType(typeName: typeName, typeNum: i + 1)
            let vc = currentIndex != 3 ? DetailRankViewController(rankType: rankType) : WeeklyRankViewController(rankType : rankType)
            childVcs.append(vc)
        }
        
        let pageView = SANPageView(frame: pageRect, titles: titles, style: style, childVcs: childVcs, parentVc: self)
        
        view.addSubview(pageView)
    }
}
