//
//  ResponseModel.swift
//  MLMNetWork_Example
//
//  Created by 孟利明 on 2020/8/6.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import HandyJSON
import MLMNetWork

/// 业务数据模型
final class ResponseModel<T> {
    var entry: T?
    var responseCode: Int?
    var status: Bool = false
    var message: String?
    
    required init() { }
}

extension ResponseModel: HandyJSON, Parsable { }

extension ResponseModel: ErrorJudge {
    var errorCode: Int {
        return self.responseCode ?? -1000
    }
    
    var errorMessage: String {
        return self.message ?? "未知错误信息"
    }
    
    var isSuccess: Bool {
        return self.status
    }
    
    func errorOccurs() {
        /// 发生错误时处理 如跳转登录等
        
    }
}
