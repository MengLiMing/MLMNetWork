//
//  Parsable+Extension.swift
//  MLMNetWork
//
//  Created by 孟利明 on 2020/8/6.
//

import Foundation
import HandyJSON

/// 支持项目中的数据解析
public extension Parsable where Self: HandyJSON {
    static func parse(data: Any?) -> Result<Self> {
        guard let data = data else {
            return Result<Self>.failure(ParseError<Self>.noData)
        }
        guard let responseJSON = data as? [String: Any] else {
            return Result<Self>.failure(ParseError<Self>.notJson(data))
        }
        guard let model = Self.deserialize(from: responseJSON) else {
            return Result<Self>.failure(ParseError<Self>.unknown(data))
        }
        return Result<Self>.success(model)
    }
}

/// 支持自定义错误信息
public extension Parsable where Self: HandyJSON & ErrorJudge {
    static func parse(data: Any?) -> Result<Self> {
        guard let data = data else {
            return Result<Self>.failure(ParseError<Self>.noData)
        }
        guard let responseJSON = data as? [String: Any] else {
            return Result<Self>.failure(ParseError<Self>.notJson(data))
        }
        guard let model = Self.deserialize(from: responseJSON) else {
            return Result<Self>.failure(ParseError<Self>.unknown(data))
        }
        if !model.isSuccess {
            /// 错误信息时额外处理
            model.errorOccurs()
            return Result<Self>.failure(ParseError<Self>.custom(model))
        }
        return Result<Self>.success(model)
    }
}
