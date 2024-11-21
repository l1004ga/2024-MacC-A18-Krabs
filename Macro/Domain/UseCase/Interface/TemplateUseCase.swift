//
//  TemplateUseCase.swift
//  Macro
//
//  Created by leejina on 11/8/24.
//

import Foundation

protocol TemplateUseCase {
    var allDefaultJangdanTemplateNames: [String] { get }
    var allCustomJangdanTemplate: [(type: Jangdan, name: String, lastUpdate: Date)] { get }
    
    func setJangdan(jangdanName: String)
    
    func createCustomJangdan(newJangdanName: String) throws

    func deleteCustomJangdan(jangdanName: String)
}
