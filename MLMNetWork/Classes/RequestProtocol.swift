//
//  RequestProtocol.swift
//  Alamofire
//
//  Created by 孟利明 on 2020/8/4.
//

import Foundation
import RxSwift

public enum RequestMethod {
    case get
    case post
}

public protocol RequestProtocol: ReactiveCompatible {
    typealias SuccessHandler = (URLSessionDataTask?, Any?) -> Void
    typealias FailHandler = (URLSessionDataTask?, Error) -> Void
    
    var path: String { get }
    var baseUrl: String { get }
    var method: RequestMethod { get }
    var parameter: [String: Any]? { get }
    var headers: [String: String]? { get }
    
    func request(successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> URLSessionTask?
}

extension RequestProtocol {
    public typealias SuccessResponseModel<T> = (URLSessionDataTask?, T, Any?) -> Void
    
    @discardableResult
    public func request<T>(successHandler: @escaping SuccessResponseModel<T>,
                           failHandler: @escaping FailHandler) -> URLSessionTask? where T: ResponseModelProtocol {
        self.request(successHandler: { (dataTask, responseObject) in
            guard let model = T.responseModel(responseObject) else {
                let error = NSError(domain: "数据解析失败", code: -200, userInfo: nil)
                failHandler(dataTask, error)
                return
            }
            if model.isSuccess {
                successHandler(dataTask, model, responseObject)
            } else {
                let error = NSError(domain: model.failMessage, code: model.failCode, userInfo: responseObject as? [String: Any])
                failHandler(dataTask, error)
            }
        }) { (dataTask, error) in
            failHandler(dataTask, error)
        }
    }
}
