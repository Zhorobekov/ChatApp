//
//  ApplicationStateLogger.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 19.02.2023.
//

import Foundation

enum ApplicationState {
    case unattached
    case foregroundInactive
    case foregroundActive
    case background
}

protocol IApplicationStateLogger {

    func printApplicationState(toState: ApplicationState, method: String)
    func printCalled(viewControllerName: String, method: String)
}

final class ApplicationLogger {
    static var instance: IApplicationStateLogger? = ApplicationLoggerImpl()
}

final class ApplicationLoggerImpl: IApplicationStateLogger {
    
    private var currentState: ApplicationState = .unattached
    
    func printApplicationState(toState: ApplicationState, method: String) {
        #if DEBUG
        print("Application moved from \(currentState) to \(toState): \(method)")
        currentState = toState
        #endif
    }
    
    func printCalled(viewControllerName: String, method: String) {
        #if DEBUG
        print("\(viewControllerName) call method: \(method)")
        #endif
    }
}
