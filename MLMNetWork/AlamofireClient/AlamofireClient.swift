//
//  AlamofireClient.swift
//  MLMNetWork
//
//  Created by 孟利明 on 2020/8/5.
//

import Foundation
import Alamofire

/// AlamofireRequest 提供网路请求
public protocol AlamofireClient: Client {
    var baseUrl: String { get }
    /// 提供默认的Header
    var baseHeaders: [String: String]? { get }
}

extension AlamofireClient {
    @discardableResult
    public func send<T>(_ request: T, completionHandler: @escaping RequestCompletedHandler<T.Response>) -> URLSessionTask? where T : Request {
        let method = HTTPMethod(rawValue: request.method.rawValue)
        var headers = HTTPHeaders(self.baseHeaders ?? [:])
        request.headers?.forEach({
            headers.add(name: $0.key, value: $0.value)
        })
        let request = AF.request(self.baseUrl + request.path,
                                 method: method,
                                 parameters: request.parameters,
                                 encoding: URLEncoding.default,
                                 headers: headers,
                                 interceptor: nil,
                                 requestModifier: nil)
        request.responseJSON { (response) in
            var dataTask: URLSessionDataTask?
            if let currentRequest = response.request {
                dataTask = AF.session.dataTask(with: currentRequest)
            }
            switch response.result {
            case let .success(responseObject):
                completionHandler(dataTask, T.Response.parse(data: responseObject))
            case let .failure(error):
                completionHandler(dataTask, MLMNetWork.Result.failure(error))
            }
        }
        return request.task
    }
}
