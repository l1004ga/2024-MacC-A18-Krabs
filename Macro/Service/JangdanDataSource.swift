//
//  JangdanDataSource.swift
//  Macro
//
//  Created by Yunki on 10/14/24.
//

// TODO: 진양, 노랫가락58855의 경우 예외처리를 진행할 예정으로 추후 추가
class JangdanDataSource {
    let jangdanList: [JangdanEntity] = [
        JangdanEntity(
            name: "진양",
            bakCount: 24,
            daebak: 24,
            bpm: 30,
            daebakList: [
                JangdanEntity.Daebak(bakAccentList: [.strong]),
                JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.strong]),
                JangdanEntity.Daebak(bakAccentList: [.strong]),
                JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.strong]),
                JangdanEntity.Daebak(bakAccentList: [.strong]),
                JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.strong]),
                JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.strong]),
                JangdanEntity.Daebak(bakAccentList: [.strong])
            ]
        ),
        JangdanEntity(
            name: "중모리",
            bakCount: 12,
            daebak: 4,
            bpm: 80,
            daebakList: [
                JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .weak]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .medium, .medium]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .weak, .strong]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .weak, .weak])
            ]
        ),
        JangdanEntity(
            name: "중중모리",
            bakCount: 12,
            daebak: 4,
            bpm: 90,
            daebakList: [
                JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .weak]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .medium, .medium]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .weak, .strong]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .weak, .weak])
            ]
        ),
        JangdanEntity(
            name: "자진모리",
            bakCount: 12,
            daebak: 4,
            bpm: 100,
            daebakList: [
                JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none])
            ]
        ),
        JangdanEntity(
            name: "굿거리",
            bakCount: 12,
            daebak: 4,
            bpm: 70,
            daebakList: [
                JangdanEntity.Daebak(bakAccentList: [.strong, .none, .weak]),
                JangdanEntity.Daebak(bakAccentList: [.medium, .none, .weak]),
                JangdanEntity.Daebak(bakAccentList: [.medium, .none, .weak]),
                JangdanEntity.Daebak(bakAccentList: [.medium, .none, .weak])
            ]
        ),
        JangdanEntity(
            name: "동살풀이",
            bakCount: 8,
            daebak: 4,
            bpm: 80,
            daebakList: [
                JangdanEntity.Daebak(bakAccentList: [.strong, .none]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .none])
            ]
        ),
        JangdanEntity(
            name: "휘모리",
            bakCount: 4,
            daebak: 2,
            bpm: 200,
            daebakList: [
                JangdanEntity.Daebak(bakAccentList: [.strong, .weak]),
                JangdanEntity.Daebak(bakAccentList: [.strong, .weak])
            ]
        ),
        JangdanEntity(
            name: "엇모리",
            bakCount: 10,
            daebak: 4,
            bpm: 200,
            daebakList: [
                JangdanEntity.Daebak(bakAccentList: [.strong, .none, .weak]),
                JangdanEntity.Daebak(bakAccentList: [.medium, .none]),
                JangdanEntity.Daebak(bakAccentList: [.medium, .none, .strong]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .none])
            ]
        ),
        JangdanEntity(
            name: "엇중모리",
            bakCount: 6,
            daebak: 6,
            bpm: 200,
            daebakList: [
                JangdanEntity.Daebak(bakAccentList: [.strong]),
                JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.weak]),
                JangdanEntity.Daebak(bakAccentList: [.strong]),
                JangdanEntity.Daebak(bakAccentList: [.weak])
            ]
        ),
        JangdanEntity(
            name: "세마치",
            bakCount: 9,
            daebak: 3,
            bpm: 80,
            daebakList: [
                JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none]),
                JangdanEntity.Daebak(bakAccentList: [.strong, .none, .medium]),
                JangdanEntity.Daebak(bakAccentList: [.strong, .medium, .none])
            ]
        ),
//        JangdanEntity(
//            name: "노랫가락 5.8.8.5.5",
//            bakCount: 31,
//            daebak: 5,
//            bpm: 110,
//            daebakList: [
//                JangdanEntity.Daebak(bakAccentList: [.strong, .none, .weak, .weak, .none]),
//                JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none, .weak, .none, .weak, .weak, .none]),
//                JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none, .weak, .none, .weak, .weak, .none]),
//                JangdanEntity.Daebak(bakAccentList: [.strong, .none, .weak, .weak, .none]),
//                JangdanEntity.Daebak(bakAccentList: [.strong, .none, .strong, .weak, .none])
//            ]
//        )
    ]
}

extension JangdanDataSource: JangdanDataInterface {
    func fetchJangdanData(jangdan: Jangdan) -> JangdanEntity? {
        return self.jangdanList.first { $0.name == jangdan.name }
    }
}
