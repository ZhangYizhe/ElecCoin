//
//  Double.swift
//  ElecCoin
//
//  Created by 张艺哲 on 2020/5/4.
//  Copyright © 2020 Elecoxy. All rights reserved.
//

import Foundation

extension Double
{
    func unixToString() -> String {
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(Int(self))
        let date = Date(timeIntervalSince1970: timeInterval)
         
        //格式话输出
        let dformatter = DateFormatter()
        dformatter.dateFormat = "MM-dd,yy"
        return dformatter.string(from: date)
    }
}
