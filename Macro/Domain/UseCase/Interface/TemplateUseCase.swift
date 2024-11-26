//
//  TemplateUseCase.swift
//  Macro
//
//  Created by leejina on 11/8/24.
//

import Foundation

protocol TemplateUseCase {
    var allDefaultJangdanTemplateNames: [String] { get }
    var allCustomJangdanTemplate: [JangdanEntity] { get }
    
    func setJangdan(jangdanName: String)
    
    func createCustomJangdan(newJangdanName: String) throws
    
    func updateCustomJangdan()

    func deleteCustomJangdan(jangdanName: String)
}
