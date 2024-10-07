//
//  MoveNextAccentInterface.swift
//  Macro
//
//  Created by leejina on 10/7/24.
//

protocol MoveNextAccentInterface {
    // 대박리스트의 각 박에 대하여 사용자가 탭을 누를 시 매개변수를 사용하여 해당 Index의 강세를 변경해줍니다.
    func moveNextAccent(daebakIndex: Int, sobakIndex: Int)
}
