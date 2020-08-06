//
//  Parsable.swift
//  MLMNetWork
//
//  Created by 孟利明 on 2020/8/5.
//

import Foundation
import HandyJSON

public typealias MParsable = MLMNetWork.Parsable

public enum ParseError: Error {
    /// 无数据
    case noData
    /// 解析失败
    case notJson(Any)
    /// 未知
    case unknown(Any)
    /// 自定义 错误码 错误信息 返回数据
    case custom(Int,String,Any)
}

public enum Result<T> {
    case success(T)
    case failure(Error)
}

/// 数据解析
public protocol Parsable {
    static func parse(data: Any?) -> Result<Self>
}


