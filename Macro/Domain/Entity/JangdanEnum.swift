//
//  JangdanEnum.swift
//  Macro
//
//  Created by Yunki on 10/14/24.
//

// TODO: 진양, 노랫가락58855의 경우 예외처리를 진행할 예정으로 추후 추가
enum Jangdan: String, CaseIterable {
    case 진양
    case 중모리
    case 중중모리
    case 자진모리
    case 굿거리
    case 휘모리
    case 동살풀이
    case 엇모리
    case 엇중모리
    case 세마치
    
//    case 노랫가락58855
    
    var name: String {
        switch self {
        case .진양: return "진양"
        case .중모리: return "중모리"
        case .중중모리: return "중중모리"
        case .자진모리: return "자진모리"
        case .굿거리: return "굿거리"
        case .휘모리: return "휘모리"
        case .동살풀이: return "동살풀이"
        case .엇모리: return "엇모리"
        case .엇중모리: return "엇중모리"
        case .세마치: return "세마치"
//        case .노랫가락58855: return "노랫가락 5.8.8.5.5"
        }
    }
}
