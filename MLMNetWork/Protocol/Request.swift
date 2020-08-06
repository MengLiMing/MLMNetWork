//
//  Request.swift
//  Alamofire
//
//  Created by 孟利明 on 2020/8/4.
//

import Foundation
import RxSwift

public typealias MRequest = MLMNetWork.Request

public enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
}

public protocol Request {
    var path: String { get set }
    var method: RequestMethod { get set }
    var parameters: [String: Any]? { get set }
    var headers: [String: String]? { get set }
    
    associatedtype Response: Parsable
}
