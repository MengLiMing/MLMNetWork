//
//  ResponseModelProtocol.swift
//  Alamofire
//
//  Created by 孟利明 on 2020/8/4.
//

import Foundation
import HandyJSON
import RxSwift

public protocol ResponseModelProtocol: HandyJSON {
    /// 是否成功还是失败的判断
    var isSuccess: Bool { get }
    /// 错误信息
    var failMessage: String { get }
    /// 错误吗
    var failCode: Int { get }
}

/// 默认实现
public extension ResponseModelProtocol {
    /// 是否成功还是失败的判断
    var isSuccess: Bool {
        return false
    }
    /// 错误信息
    var failMessage: String {
        return "未知错误"
    }
    /// 错误吗
    var failCode: Int {
        return -200
    }
}

public extension ResponseModelProtocol {
    typealias SuccessHandler = (URLSessionDataTask?, Self?, Any?) -> Void
    typealias FailHandler = (URLSessionDataTask?, Error) -> Void
    
    /// 数据解析
    static func responseModel(_ responseObject: Any) -> Self? {
        guard let responseJSON = responseObject as? [String: Any] else {
            return nil
        }
        return Self.deserialize(from: responseJSON)
    }
    
    /// 扩展提供发起网络请求的能力
    static func sendRequest<T: RequestProtocol>(by request: T,
                            successHandler: @escaping SuccessHandler,
                            failHandler: @escaping FailHandler) {
        request.request(successHandler: { (dataTask: URLSessionDataTask?, model: Self?, responseObject: Any?) in
            successHandler(dataTask, model, responseObject)
        }) { (dataTask, error) in
            failHandler(dataTask, error)
        }
    }
}

