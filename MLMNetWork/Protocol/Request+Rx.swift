//
//  RequestProtocol+Rx.swift
//  MLMNetWork
//
//  Created by 孟利明 on 2020/8/4.
//

import Foundation
import RxSwift

public extension Reactive where Base: Client {
    func send<T: Request>(_ request: T) -> Observable<T.Response> {
        typealias R = T.Response
        return Observable<R>.create { (observer) -> Disposable in
            let task = self.base.send(request) { (_, result) in
                switch result {
                case let .success(response):
                    observer.onNext(response)
                case let .cache(cacehResponse):
                    observer.onNext(cacehResponse)
                case let .failure(error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
