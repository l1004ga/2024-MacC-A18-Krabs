//
//  JangdanTemplateRepository.swift
//  Macro
//
//  Created by Yunki on 10/14/24.
//

protocol JangdanTemplateRepository {
    func fetchJangdanData(jangdan: Jangdan) -> JangdanEntity?
}
