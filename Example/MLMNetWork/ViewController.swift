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
        
        let request = Request<[Category]>()
        request.path = "/item-center/material/category/list"
        request.parameters = [
            "materialType":1
        ]
        request.method = .get
        request.headers = nil
        
        /// Completion
        NetWorkClient.share.send(request) { (_, result) in
            switch result {
            case let .success(response):
                print(response.entry ?? [])
            case let .failure(error):
                print(error)
            }
        }
        
        // Success/Failure
        NetWorkClient.share.send(request, successHandler: { (_, response) in
            print(response.entry ?? [])
        }) { (_, error) in
            print(error)
        }
        
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
