//
//  JangdanEnum.swift
//  Macro
//
//  Created by Yunki on 10/14/24.
//

enum Jangdan: String, CaseIterable {
    case 자진모리
    case 중모리
    case 굿거리
    case 세마치
    case 휘모리
    
    var name: String {
        switch self {
        case .자진모리: return "자진모리"
        case .중모리: return "중모리"
        case .굿거리: return "굿거리"
        case .세마치: return "세마치"
        case .휘모리: return "휘모리"
        }
    }
}
