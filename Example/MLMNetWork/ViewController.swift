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
        let request = Request<Any>()
        request.path = "/app-web/advertPositions/list"
        request.method = .get
        request.parameters = [
            "pageId": "0"
        ]
        
        /// Completion
//        NetWorkClient.share.send(request) { (_, result) in
//            switch result {
//            case let .success(response):
//                print(response.entry ?? [])
//            case let .cache(response):
//                print(response.entry ?? [])
//            case let .failure(error):
//                print(error)
//            }
//        }
        
        // Success/Failure
//        NetWorkClient.share.send(request) { (_, response) in
//            print(response.entry ?? [])
//        } cacheHandler: { (_, response) in
//            print(response.entry ?? [])
//        } failureHandler: { (_, error) in
//            print(error)
//        }

        // RX
        NetWorkClient.share.rx.send(request).subscribe(onNext: {
            print($0.entry ?? [])
        }).disposed(by: disposeBag)
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
