//
//  AlamofireRequest.swift
//  MLMNetWork
//
//  Created by 孟利明 on 2020/8/4.
//

import Foundation
import Alamofire

/// AlamofireRequest 提供网路请求
public protocol AlamofireRequest: RequestProtocol {
}

extension AlamofireRequest {
    public var method: RequestMethod {
        return .post
    }
}

extension AlamofireRequest {
    fileprivate var alamofireMethod: HTTPMethod {
        switch self.method {
        case .get:
            return .get
        case .post:
            return .post
        }
    }
    
    fileprivate var alamofireHeaders: HTTPHeaders? {
        guard let headers = self.headers else {
            return nil
        }
        return HTTPHeaders(headers)
    }
    
    @discardableResult
    public func request(successHandler: @escaping (URLSessionDataTask?, Any?) -> Void, failHandler: @escaping (URLSessionDataTask?, Error) -> Void) -> URLSessionTask? {
        let request = AF.request(self.baseUrl + self.path, method: self.alamofireMethod, parameters: self.parameter, encoding: URLEncoding.default, headers: self.alamofireHeaders, interceptor: nil, requestModifier: nil).responseJSON { response in
            var dataTask: URLSessionDataTask?
            if let request = response.request {
                dataTask = URLSession().dataTask(with: request)
            }
            switch response.result {
            case let .success(responseObject):
                successHandler(dataTask, responseObject)
            case let .failure(error):
                failHandler(dataTask, error)
            }
        }
        return request.task
    }
}

