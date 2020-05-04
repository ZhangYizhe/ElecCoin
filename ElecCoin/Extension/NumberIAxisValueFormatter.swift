//
//  NumberIAxisValueFormatter.swift
//  ElecCoin
//
//  Created by 张艺哲 on 2020/5/4.
//  Copyright © 2020 Elecoxy. All rights reserved.
//

import UIKit
import Charts

class NumberIAxisValueFormatter: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if value >= 1000 {
            return "\(Int(value) / 1000)k"
        } else {
            return "\(value)"
        }
    }
}
