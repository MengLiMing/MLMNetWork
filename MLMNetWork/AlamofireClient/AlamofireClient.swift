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
    
    /// 默认为URLEncoding.default 如果Content-Type == application/json 则返回 JSONEncoding.default
    var encodingByJson: Bool { get }
}

public extension AlamofireClient {
    var baseHeaders: [String: String]? {
        return nil
    }
    
    var encodingByJson: Bool {
        return true
    }
}

extension AlamofireClient {
    @discardableResult
    public func send<T>(_ request: T, completionHandler: @escaping RequestCompletedHandler<T.Response>) -> URLSessionTask? where T : Request {
        var encoding: ParameterEncoding = URLEncoding.default
        if request.method == .post && self.encodingByJson {
            encoding = JSONEncoding.default
        }
        let method = HTTPMethod(rawValue: request.method.rawValue)
        var headers = HTTPHeaders(self.baseHeaders ?? [:])
        request.headers?.forEach({
            headers.add(name: $0.key, value: $0.value)
        })
        request.parseQueue.async {
            if let responseObject = request.parseCache(),
               case let .cache(_) = responseObject {
                DispatchQueue.main.async {
                    completionHandler(nil, responseObject)
                }
            }
        }
        let dataRequest = AF.request(self.baseUrl + request.path,
                                 method: method,
                                 parameters: request.parameters,
                                 encoding: encoding,
                                 headers: headers,
                                 interceptor: nil,
                                 requestModifier: nil)
        dataRequest.responseSpecialJSON { (response) in
            var dataTask: URLSessionDataTask?
            if let currentRequest = response.request {
                dataTask = AF.session.dataTask(with: currentRequest)
            }
            switch response.result {
            case let .success(responseObject):
                request.parseQueue.async {
                    request.cache(responseObject)
                    let result = T.Response.parse(data: responseObject)
                    DispatchQueue.main.async {
                        completionHandler(dataTask, result)
                    }
                }
            case let .failure(error):
                /// 添加进解析数据线程 保证在网络请求失败的情况下，cache执行后执行error，
                /// rx执行error后 不执行onNext 导致bug
                request.parseQueue.async {
                    DispatchQueue.main.async {
                        completionHandler(dataTask, MLMNetWork.Result.failure(error))
                    }
                }
            }
        }
        return dataRequest.task
    }
}


/// 处理JSON中unicode无法解析的问题 例如："title": "\uDCAB"
extension DataRequest {
    @discardableResult
    public func responseSpecialJSON(queue: DispatchQueue = .main,
                             dataPreprocessor: DataPreprocessor = JSONSpecialResponseSerializer.defaultDataPreprocessor,
                             emptyResponseCodes: Set<Int> = JSONSpecialResponseSerializer.defaultEmptyResponseCodes,
                             emptyRequestMethods: Set<HTTPMethod> = JSONSpecialResponseSerializer.defaultEmptyRequestMethods,
                             options: JSONSerialization.ReadingOptions = .allowFragments,
                             completionHandler: @escaping (AFDataResponse<Any>) -> Void) -> Self {
        response(queue: queue,
                 responseSerializer: JSONSpecialResponseSerializer(dataPreprocessor: dataPreprocessor,
                                                            emptyResponseCodes: emptyResponseCodes,
                                                            emptyRequestMethods: emptyRequestMethods,
                                                            options: options),
                 completionHandler: completionHandler)
    }
}

public final class JSONSpecialResponseSerializer: ResponseSerializer {
    public let dataPreprocessor: DataPreprocessor
    public let emptyResponseCodes: Set<Int>
    public let emptyRequestMethods: Set<HTTPMethod>
    public let options: JSONSerialization.ReadingOptions

    public init(dataPreprocessor: DataPreprocessor = JSONSpecialResponseSerializer.defaultDataPreprocessor,
                emptyResponseCodes: Set<Int> = JSONSpecialResponseSerializer.defaultEmptyResponseCodes,
                emptyRequestMethods: Set<HTTPMethod> = JSONSpecialResponseSerializer.defaultEmptyRequestMethods,
                options: JSONSerialization.ReadingOptions = .allowFragments) {
        self.dataPreprocessor = dataPreprocessor
        self.emptyResponseCodes = emptyResponseCodes
        self.emptyRequestMethods = emptyRequestMethods
        self.options = options
    }

    public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> Any {
        guard error == nil else { throw error! }

        guard var data = data, !data.isEmpty else {
            guard emptyResponseAllowed(forRequest: request, response: response) else {
                throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
            }

            return NSNull()
        }

        data = try dataPreprocessor.preprocess(data)

        do {
            return try JSONSerialization.jsonObject(with: data, options: options)
        } catch {
            guard let str = String(data: data, encoding: .utf8),
                  let transformStr = str.applyingTransform(StringTransform(rawValue: "Any-Hex/Java"), reverse: true),
                  let transformData = transformStr.data(using: .utf8),
                  let obj = try? JSONSerialization.jsonObject(with: transformData, options: options)  else {
                throw AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error))
            }
            return obj
        }
    }
}
