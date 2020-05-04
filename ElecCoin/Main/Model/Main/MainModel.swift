//
//  MainModel.swift
//  ElecCoin
//
//  Created by 张艺哲 on 2020/5/4.
//  Copyright © 2020 Elecoxy. All rights reserved.
//

import Foundation
import SwiftyJSON

enum timespan: Int {
    case thirtyDays = 0
    case sixtyDays
    case halfYear
    case oneYear
    case threeYears
    case all
}

enum daysAverage: Int {
    case rawValues = 0
    case sevenDays
    case thirtyDays
}

class MainModel {
    
    struct Value {
        var x: Double
        var y: Double
    }
    
    var values = [Value]()
    
    //Get the data behind Blockchain's charts
    func MarketPriceRequest(timespan: timespan,
                                   daysAverage: daysAverage,
                                   completion: @escaping (Result<String, Error>) -> Void)
    {
        var timespanStr = ""
        switch timespan {
        case .thirtyDays:
            timespanStr = "30days"
        case .sixtyDays:
            timespanStr = "60days"
        case .halfYear:
            timespanStr = "180days"
        case .oneYear:
            timespanStr = "1year"
        case .threeYears:
            timespanStr = "3years"
        case .all:
            timespanStr = "all"
        }
        
        var daysAverageStr = ""
        switch daysAverage {
        case .rawValues:
            daysAverageStr = ""
        case .sevenDays:
            daysAverageStr = "7D"
        case .thirtyDays:
            daysAverageStr = "30D"
        }
        
        BolckChainProvider.request(.marketPrice(timespan: timespanStr, daysAverageString: daysAverageStr, sampled: "true", metadata: "false", cors: "true", format: "json")) { [weak self] (result) in
            guard let self = self else {
                completion(.failure(MoyaError.init("Error")))
                return
            }
            
            switch result {
            case let .success(response):
                //解析数据
                if let data = try? response.mapJSON() {
                    let json = JSON(data)
                    self.values = []
                    for valueJSON in json["values"].arrayValue {
                        let value = Value(x: valueJSON["x"].doubleValue, y: valueJSON["y"].doubleValue)
                        self.values.append(value)
                    }
                    completion(.success("Success"))
                } else {
                    completion(.failure(MoyaError.init("Data Error")))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
