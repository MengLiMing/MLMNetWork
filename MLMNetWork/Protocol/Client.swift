//
//  Client.swift
//  MLMNetWork
//
//  Created by 孟利明 on 2020/8/5.
//

import Foundation

public typealias RequestCompletedHandler<T> = (URLSessionDataTask?, Result<T>) -> Void
public typealias RequestSuccessHandler<T> = (URLSessionDataTask?, T) -> Void
public typealias RequestFailureHandler = (URLSessionDataTask?, Error) -> Void

public typealias MClient = MLMNetWork.Client

/// 请求委托
public protocol Client {
    func send<T: Request>(_ request: T, completionHandler: @escaping RequestCompletedHandler<T.Response>) -> URLSessionTask?
}

public extension Client {
    @discardableResult
    func send<T: Request>(_ request: T, successHandler: @escaping RequestSuccessHandler<T.Response>, failureHandler: @escaping RequestFailureHandler) -> URLSessionTask? {
        return self.send(request) { (dataTask, result) in
            switch result {
            case let .success(response):
                successHandler(dataTask, response)
            case let .failure(error):
                failureHandler(dataTask, error)
            }
        }
    }
    
}
