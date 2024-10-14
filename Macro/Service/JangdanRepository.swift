//
//  JangdanRepository.swift
//  Macro
//
//  Created by Yunki on 10/14/24.
//

class JangdanRepository {
    let jangdanList: [JangdanEntity] = [
        JangdanEntity(
            name: "자진모리",
            bakCount: 12,
            daebak: 4,
            bpm: 140,
            daebakList: [
                JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .medium]),
                JangdanEntity.Daebak(bakAccentList: [.medium, .weak, .weak]),
                JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .medium]),
                JangdanEntity.Daebak(bakAccentList: [.medium, .weak, .weak])
            ]
        ),
        JangdanEntity(
            name: "중모리",
            bakCount: 12,
            daebak: 4,
            bpm: 100,
            daebakList: [
                JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .weak]),
                JangdanEntity.Daebak(bakAccentList: [.medium, .weak, .weak]),
                JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .weak]),
                JangdanEntity.Daebak(bakAccentList: [.medium, .weak, .weak])
            ]
        ),
        JangdanEntity(
            name: "굿거리",
            bakCount: 12,
            daebak: 4,
            bpm: 120,
            daebakList: [
                JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .medium]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .medium, .weak]),
                JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .medium]),
                JangdanEntity.Daebak(bakAccentList: [.weak, .medium, .weak])
            ]
        ),
        JangdanEntity(
            name: "세마치",
            bakCount: 9,
            daebak: 3,
            bpm: 130,
            daebakList: [
                JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .medium]),
                JangdanEntity.Daebak(bakAccentList: [.medium, .weak, .weak]),
                JangdanEntity.Daebak(bakAccentList: [.strong, .medium, .weak])
            ]
        ),
        JangdanEntity(
            name: "휘모리",
            bakCount: 12,
            daebak: 4,
            bpm: 180,
            daebakList: [
                JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .weak]),
                JangdanEntity.Daebak(bakAccentList: [.medium, .weak, .weak]),
                JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .weak]),
                JangdanEntity.Daebak(bakAccentList: [.medium, .weak, .weak])
            ]
        )
    ]
}

extension JangdanRepository: JangdanDataInterface {
    func fetchJangdanData(jangdan: Jangdan) -> JangdanEntity? {
        return self.jangdanList.first { $0.name == jangdan.name }
    }
}
