//
//  FucusViewModel.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/6/7.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class FucusViewModel: HomeViewModel {

}

extension FucusViewModel {
    func loadFucusData(completion : () -> ()) {
        let dataArray = SqliteTools.querySQL("SELECT * FROM t_focus;")
        
        for dict in dataArray {
            self.anchorModels.append(AnchorModel(dict: dict))
        }
        
        completion()
    }
}
