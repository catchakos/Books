//
//  Logger.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 27/10/22.
//

import Foundation

class Logger {
    enum LogLevel {
        case none
        case debug
    }
    
#if DEBUG
    static let logLevel: LogLevel = .debug
#else
    static let logLevel: LogLevel = .none
#endif
    
    static func log(file: String = #file, _ string: String?) {
        guard Logger.logLevel == .debug else {
            return
        }
        
        guard let filename = file.components(separatedBy: "/").last?.components(separatedBy: ".").first else {
            return
        }
        
        if let string {
            print("[\(filename)]: \(string)")
        } else {
            print("[\(filename)]: nil")
        }

    }
}
