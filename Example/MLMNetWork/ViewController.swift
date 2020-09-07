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
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let request = Request<[Category]>()
        request.path = ""
        request.parameters = [
            "loginType": "ACCOUNT",
            "accountLoginRequest": [
                "mobile": "13014795306",
                "password": "12345678",
                "countryCode": "86"
            ]
        ]
        request.method = .post
        
        /// Completion
        //        NetWorkClient.share.send(request) { (_, result) in
        //            switch result {
        //            case let .success(response):
        //                print(response.entry ?? [])
        //            case let .failure(error):
        //                print(error)
        //            }
        //        }
        
        // Success/Failure
        NetWorkClient.share.send(request, successHandler: { (_, response) in
            print(response.entry ?? [])
        }) { (_, error) in
            print(error)
        }
        
        // RX
        //                NetWorkClient.share.rx.send(request).subscribe(onNext: {
        //                    print($0.entry ?? [])
        //                }).disposed(by: disposeBag)
    }
}

class Category: HandyJSON {
    var catId: Int?
    var catName: String?
    
    required init() { }
}

extension Dictionary {
    func jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}
