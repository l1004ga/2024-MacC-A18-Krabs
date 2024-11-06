//
//  TemplateUseCase.swift
//  Macro
//
//  Created by Lee Wonsun on 10/3/24.
//

class TemplateUseCase {
    // 장단의 정보를 저장하고 있는 레이어
    private var jangdanRepository: JangdanRepository
    
    init(jangdanRepository: JangdanRepository) {
        self.jangdanRepository = jangdanRepository
    }
}

extension TemplateUseCase {
    func setJangdan(jangdan: Jangdan) {
        self.jangdanRepository.fetchJangdanData(jangdan: jangdan)
    }
}
