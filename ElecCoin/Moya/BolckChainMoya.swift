//
//  BolckChainMoya.swift
//  ElecCoin
//
//  Created by 张艺哲 on 2020/5/4.
//  Copyright © 2020 Elecoxy. All rights reserved.
//
import Foundation
import Moya

//初始化请求的provider
let BolckChainProvider = MoyaProvider<BolckChainMoya>()

//请求分类
public enum BolckChainMoya {
    case marketPrice(timespan: String, daysAverageString: String, sampled: String, metadata: String, cors: String, format: String)
}

//请求配置
extension BolckChainMoya: TargetType {
    // 服务器地址
    public var baseURL: URL {
        return URL(string: "https://api.blockchain.info")!
    }

    
    // 各个请求的具体路径
    public var path: String {
        switch self {
        case .marketPrice:
            return "/charts/market-price"
        }
    }
    
    //请求类型
    public var method: Moya.Method {
        return .get
    }
    
    //请求任务事件
    public var task: Task {
        switch self {
        case .marketPrice(timespan: let timespan, daysAverageString: let daysAverageString, sampled: let sampled, metadata: let metadata, cors: let cors, format: let format):
            var params: [String: Any] = [:]
            params["timespan"] = timespan
            params["daysAverageString"] = daysAverageString
            params["sampled"] = sampled
            params["metadata"] = metadata
            params["cors"] = cors
            params["format"] = format
            return .requestParameters(parameters: params,
                                      encoding: URLEncoding.default)
        }
    }
    
    // 是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    
    // 单元测试模拟
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    // 请求头
    public var headers: [String: String]? {
        return nil
    }
}
