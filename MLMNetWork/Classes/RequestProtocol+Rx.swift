//
//  RequestProtocol+Rx.swift
//  MLMNetWork
//
//  Created by 孟利明 on 2020/8/4.
//

import Foundation
import RxSwift

public extension Reactive where Base: RequestProtocol {
    func request<T>() -> Observable<T> where T: ResponseModelProtocol {
        return Observable<T>.create { (observer) -> Disposable in
            let task = self.base.request(successHandler: { (dataTask, model: T, responseObject) in
                observer.onNext(model)
                observer.onCompleted()
            }) { (task, error) in
                observer.onError(error)
            }
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
