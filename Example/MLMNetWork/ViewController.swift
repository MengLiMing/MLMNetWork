//
//  ViewController.swift
//  MLMNetWork
//
//  Created by MengLiMing on 07/06/2020.
//  Copyright (c) 2020 MengLiMing. All rights reserved.
//

import UIKit
import RxSwift
import MLMNetWork
import Alamofire
import HandyJSON

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Request.userInfo.request(successHandler: { (_, model: ResponseModel<UserInfo>, _) in
            
        }) { (_, _) in
            
        }
        
        ResponseModel<UserInfo>.sendRequest(by: Request.userInfo, successHandler: { (task, model, responseObject) in
            
        }) { (_, _) in
            
        }
        
        let observable: Observable<ResponseModel<UserInfo>> = Request.userInfo.rx.request()
        observable.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    }
}

class ResponseModel<T>: ResponseModelProtocol {
    var isSuccess: Bool {
        return false
    }
    
    var data: T?
    
    required init() { }
}

class UserInfo: HandyJSON {
    required init() { }
}


enum Request {
    case userInfo
}

extension Request: AlamofireRequest {
    var path: String {
        return ""
    }
    
    var baseUrl: String {
        return ""
    }
    
    var parameter: [String : Any]? {
        return nil
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
