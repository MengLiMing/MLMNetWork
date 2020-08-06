//
//  NetWorkClient.swift
//  MLMNetWork_Example
//
//  Created by 孟利明 on 2020/8/6.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import MLMNetWork
import RxSwift

final class NetWorkClient: AlamofireClient {
    
    static let share = NetWorkClient()
    
    fileprivate init() { }
    
    lazy var baseHeaders: [String : String]? = {
        return [
            "zmjx_client":"1",
        ]
    }()
    
    var baseUrl: String {
        return "https://api.zmjx.com"
    }
}

extension NetWorkClient: ReactiveCompatible { }
