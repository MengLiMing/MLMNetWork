//
//  ErrorJudge.swift
//  MLMNetWork
//
//  Created by 孟利明 on 2020/8/6.
//

import Foundation

/// 请求错误判断
public protocol ErrorJudge {
    var errorCode: Int { get }
    var isSuccess: Bool { get }
    var errorMessage: String { get }
    
    /// 出现错误时的额外操作
    func errorOccurs()
}

public extension ErrorJudge {
    func errorOccurs() {
    }
}
