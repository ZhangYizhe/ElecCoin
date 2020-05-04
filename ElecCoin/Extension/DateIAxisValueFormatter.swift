//
//  DateIValueFormatter.swift
//  ElecCoin
//
//  Created by 张艺哲 on 2020/5/4.
//  Copyright © 2020 Elecoxy. All rights reserved.
//

import UIKit
import Charts

class DateIAxisValueFormatter: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return value.unixToString()
    }
}
