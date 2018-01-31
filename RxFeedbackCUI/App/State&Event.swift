//
//  State&Event.swift
//  RxFeedbackCUI
//
//  Created by YutoMizutani on 2018/01/31.
//  Copyright © 2018 Yuto Mizutani.
//  This software is released under the MIT License.
//

import Foundation
import RxSwift
import RxCocoa
import RxFeedback

public enum State {
    case ready
    case looping
    case sleeping
    case ending
}

public enum Event {
    case goStart
    case goSleep
    case goWakeUp
    case goEnd
    case response
    case noChange
}

public extension State {
    static var initialState: State {
        return State.ready
    }

    public var stateString: String {
        switch self {
        case .ready:
            return "==== STATE: READY ===="
        case .looping:
            return "==== STATE: WORKING ===="
        case .sleeping:
            return "==== STATE: SLEEP ===="
        case .ending:
            return "==== STATE: FINISH ===="
        }
    }
}

public extension Event {
    /// textと一致するEventを返す。
    public static func throwState(_ text: String) -> Event {
        switch text.lowercased() {
        case "goStart".lowercased(), "start".lowercased(), "s":
            return .goStart
        case "goSleep".lowercased(), "sleep".lowercased():
            return .goSleep
        case "goWakeUp".lowercased(), "wakeUp".lowercased():
            return .goWakeUp
        case "goEnd".lowercased(), "end".lowercased():
            return .goEnd
        case "response".lowercased(), "r":
            return .response
        default:
            return .noChange
        }
    }
}
