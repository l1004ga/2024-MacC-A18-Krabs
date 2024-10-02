//
//  JangdanSelectInterface.swift
//  Macro
//
//  Created by Yunki on 10/1/24.
//

// 장단 선택하는 UseCase용
import Combine

protocol JangdanSelectInterface {
    var jangdanPublisher: AnyPublisher<[Accent], Never> { get }
    var bpmPublisher: AnyPublisher<Int, Never> { get }
}
