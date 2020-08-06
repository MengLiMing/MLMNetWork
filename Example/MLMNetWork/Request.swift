//
//  Request.swift
//  MLMNetWork_Example
//
//  Created by 孟利明 on 2020/8/6.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import MLMNetWork

class Request<Data>: MRequest  {    
    typealias Response = ResponseModel<Data>

    var headers: [String : String]?
    
    var method: RequestMethod = .post
    
    var path: String = ""
    
    var parameters: [String : Any]?
    
}
