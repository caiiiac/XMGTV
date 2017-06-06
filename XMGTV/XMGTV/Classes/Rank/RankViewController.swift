//
//  RankViewController.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/5/31.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

private let ReuseIdentifier = "RankCollectionViewCell"

class RankViewController: UIViewController {
    
    fileprivate lazy var collectionView : UICollectionView = {
       let layout = SANWaterfallFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        layout.minimumLineSpacing = 10
        layout.minimumLineSpacing = 10
        
        layout.dataSource = self
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ReuseIdentifier)
    }

    
}

extension RankViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier, for: indexPath)
        cell.contentView.backgroundColor = UIColor.randomColor()
        
        return cell
    }
}

extension RankViewController : SANWaterfallFlowLayoutDataSource {
    func numberOfCols(_ waterfall: SANWaterfallFlowLayout) -> Int {
        return 3
    }
    func waterfall(_ waterfall: SANWaterfallFlowLayout, item: Int) -> CGFloat {
        return CGFloat(arc4random_uniform(100) + 100)
    }
}
