//
//  TemplateUseCase.swift
//  Macro
//
//  Created by leejina on 11/8/24.
//

protocol TemplateUseCase {
    var allDefaultJangdanTemplateNames: [String] { get }
    var allCustomJangdanTemplateNames: [String] { get }
    
    func setJangdan(jangdanName: String)
    
    func createCustomJangdan(newJangdanName: String) throws
    
    func editCustomJangdan(targetName: String, newData: JangdanEntity) throws
    
    func deleteCustomJangdan(target: JangdanEntity)
}
