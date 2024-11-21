//
//  MetronomeOnOffUseCase.swift
//  Macro
//
//  Created by leejina on 11/8/24.
//

protocol MetronomeOnOffUseCase {
    func changeSobak()
    func play(_ tickHandler: @escaping () -> Void )
    func stop()
    func setSoundType()
}
