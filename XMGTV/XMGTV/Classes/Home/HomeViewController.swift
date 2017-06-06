//
//  HomeViewController.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/5/31.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupUI()
        
    }

}

// MARK:- UI
extension HomeViewController {
    fileprivate func setupUI() {
        setupNavigationBar()
        automaticallyAdjustsScrollViewInsets = false
        let frame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64 - 49)
        
        let titles = ["全部", "娱乐", "搞笑","搞搞笑搞笑笑","搞笑","搞搞笑笑","搞笑","搞笑","搞搞笑搞笑搞笑笑"]
        var vcs = [UIViewController]()
        for _ in titles {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            
            vcs.append(vc)
            
        }
        let style = SANTitleStyle()
        style.isScrollEnable = true
        style.isShowScrollLine = true
        
        let page = SANPageView(frame: frame, titles: titles, childVcs: vcs, parentVc: self, style: style)
        view.addSubview(page)
        
    }
    
    fileprivate func setupNavigationBar() {
        // 左侧logoItem
        let logoImage = UIImage(named: "home-logo")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .plain, target: nil, action: nil)
        
        // 设置右侧收藏的item
        let collectImage = UIImage(named: "search_btn_follow")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: collectImage, style: .plain, target: self, action: #selector(followItemClick))
        
        
        // 搜索框
        let searchFrame = CGRect(x: 0, y: 0, width: 200, height: 32)
        let searchBar = UISearchBar(frame: searchFrame)
        searchBar.placeholder = "主播昵称/房间号/链接"
        navigationItem.titleView = searchBar
        searchBar.searchBarStyle = .minimal
        let searchFiled = searchBar.value(forKey: "_searchField") as? UITextField
        searchFiled?.textColor = UIColor.white

    }
}

// MARK:- 事件监听函数
extension HomeViewController {
    @objc fileprivate func followItemClick() {
        print("------")
    }
}
