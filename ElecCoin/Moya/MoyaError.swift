//
//  MoyaError.swift
//  ElecCoin
//
//  Created by 张艺哲 on 2020/5/4.
//  Copyright © 2020 Elecoxy. All rights reserved.
//

import Foundation

struct MoyaError: LocalizedError {
    var desc = ""
    var localizedDescription: String {
        return desc
    }
    
    init(_ desc: String) {
        self.desc = desc
    }
}
