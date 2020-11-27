//
//  Request.swift
//  Alamofire
//
//  Created by 孟利明 on 2020/8/4.
//

import Foundation
import RxSwift

public typealias MRequest = MLMNetWork.Request

public struct RequestMethod: RawRepresentable {
    /// `GET` method.
    public static let get = RequestMethod(rawValue: "GET")
    /// `POST` method.
    public static let post = RequestMethod(rawValue: "POST")
    /// `DELETE` method.
    public static let delete = RequestMethod(rawValue: "DELETE")

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public enum RequestCachePolicy {
    /// 只加载远端数据
    case justRemote
    /// 缓存+远端数据
    case cacheAndRemote
}

public protocol Request {
    var path: String { get set }
    var method: RequestMethod { get set }
    var parameters: [String: Any]? { get set }
    var headers: [String: String]? { get set }
    
    associatedtype Response: Parsable
    
    /// 缓存
    func cache(_ response: Any?)
    /// 获取缓存
    func cache() -> Any?
    /// 缓存策略
    var cachePolicy: RequestCachePolicy { get }
    /// 数据解析的子线程
    var parseQueue: DispatchQueue { get }
}

private let requestParseQueue: DispatchQueue = DispatchQueue(label: "com.MLMNetWork.parseQueue", qos: .userInteractive)

public extension Request {
    func cache(_ response: Any?) { }
    func cache() -> Any? { return nil }
    var cachePolicy: RequestCachePolicy {
        return .justRemote
    }
    var parseQueue: DispatchQueue {
        return requestParseQueue
    }
}

internal extension Request {
    func parseCache() -> Result<Response>? {
        if self.cachePolicy == .justRemote {
            return nil
        }
        guard let responseObject = self.cache() else {
            return nil
        }
        let result = Response.parse(data: responseObject, isCache: true)
        return result
    }
}
