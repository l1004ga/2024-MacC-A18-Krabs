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
    
    var englishName: String {
        switch self {
        case .진양: return "Jinyang"
        case .중모리: return "Jungmori"
        case .중중모리: return "Jungjungmori"
        case .자진모리: return "Jajinmori"
        case .굿거리: return "Gutgeori"
        case .휘모리: return "Hwimori"
        case .동살풀이: return "Dongsalpuri"
        case .엇모리: return "Eotmori"
        case .엇중모리: return "Eotjungmori"
        case .세마치: return "Semachi"
        }
    }
    
    var sobakSegmentCount: Int? {
        switch self {
        case .진양: return 3
        case .중모리: return 2
        case .엇중모리: return 2
        default: return nil
        }
    }
    
    var bakInformation: String {
        switch self {
        case .진양: return "24박 3소박"
        case .중모리: return "12박 2소박"
        case .중중모리: return "4박 3소박"
        case .자진모리: return "4박 3소박"
        case .굿거리: return "4박 3소박"
        case .휘모리: return "4박 2소박"
        case .동살풀이: return "4박 2소박"
        case .엇모리: return "4박 3+2소박"
        case .엇중모리: return "6박 2소박"
        case .세마치: return "3박 3소박"
        }
    }
    
    var bakData: String {
        switch self {
        case .동살풀이: return "4박 2소박"
        default: return "수정해라"
        }
    }
}
