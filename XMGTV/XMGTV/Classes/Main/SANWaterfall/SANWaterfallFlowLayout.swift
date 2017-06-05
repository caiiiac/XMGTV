//
//  SANWaterfallFlowLayout.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/6/5.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit


protocol SANWaterfallFlowLayoutDataSource : class {
    func numberOfCols(_ waterfall : SANWaterfallFlowLayout) -> Int
    func waterfall(_ waterfall : SANWaterfallFlowLayout, item : Int) -> CGFloat
    
}

class SANWaterfallFlowLayout: UICollectionViewFlowLayout {

    weak var dataSource : SANWaterfallFlowLayoutDataSource?
    
    fileprivate lazy var cellAttrs : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate lazy var cols : Int = {
       return self.dataSource?.numberOfCols(self) ?? 2
    }()
    fileprivate lazy var totalHeights : [CGFloat] = Array(repeating: self.sectionInset.top, count: self.cols)
}

//MARK: - 准备布局
extension SANWaterfallFlowLayout {
    override func prepare() {
        super.prepare()
        
        //获取cell个数
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        
        //创建每个cell的UICollectionViewLayoutAttributes
        let cellW : CGFloat = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - CGFloat(cols - 1) * minimumInteritemSpacing) / CGFloat(cols)
        
        for i in 0..<itemCount {
            //创建indexPath
            let indexPath = IndexPath(item: i, section: 0)
            
            //创建UICollectionViewLayoutAttributes
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            //设置frame
            guard let cellH : CGFloat = dataSource?.waterfall(self, item: i) else {
                fatalError("waterfall(_ waterfall : SANWaterfallFlowLayout, item : Int) -> CGFloat")
            }
            let minH = totalHeights.min()!
            let minIndex = totalHeights.index(of: minH)!
            let cellX : CGFloat = sectionInset.left + (minimumInteritemSpacing + cellW) * CGFloat(minIndex)
            let cellY : CGFloat = minH + minimumLineSpacing
            attr.frame = CGRect(x: cellX, y: cellY, width: cellW, height: cellH)
            
            //保存attr
            cellAttrs.append(attr)
            
            //替换当前列高度
            totalHeights[minIndex] = minH + minimumLineSpacing + cellH
        }
    }
}

//MARK: - 返回所有布局
extension SANWaterfallFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttrs
    }
}

//MARK: - 设置contentSize
extension SANWaterfallFlowLayout {
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: totalHeights.max()! + sectionInset.bottom)
    }
}

