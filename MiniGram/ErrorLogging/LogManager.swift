//
//  LogManager.swift
//  MiniGram
//
//  Created by Keegan Black on 2/12/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

/*
 Simple Logging Manager to consolidate log format.
 Allows custom behavior, like logging errors to database when they arise
 */

import Foundation

struct LogManager {
    
    static func logError<T>(_ error: T) {
        print("[ERROR]", error)
//        Log error to database
    }
    static func logInfo<T>(_ info: T) {
        print("[INFO]", info)
    }
        
}
