//
//  BeatDisplayUseCase.swift
//  Macro
//
//  Created by Yunki on 10/7/24.
//

class BeatDisplayUseCase {
    private var tickHandler: () -> Void
    
    init(tickHandler: @escaping () -> Void) {
        self.tickHandler = tickHandler
    }
}

extension BeatDisplayUseCase: UpdateBeatDisplayInterface {
    func nextBeat() async {
        tickHandler()
    }
}
