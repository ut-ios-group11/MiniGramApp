//
//  Theme.swift
//  MiniGram
//
//  Created by Keegan Black on 4/14/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import Foundation
import UIKit

class Theme {
    enum ThemeEnum: String {
        case system
        case dark
        case light
    }
    
    static func updateSystemToCurrentState() {
        updateSystemToTheme(getCurrentTheme())
    }
    
    static func getCurrentTheme() -> ThemeEnum {
        let currentThemeValue = UserDefaults.standard.string(forKey: "theme")
        return ThemeEnum(rawValue: currentThemeValue ?? "system") ?? ThemeEnum.system
    }
    
    static func setCurrentTheme(_ theme: ThemeEnum) {
        UserDefaults.standard.set(theme.rawValue, forKey: "theme")
        updateSystemToTheme(theme)
    }
    
    private static func updateSystemToTheme(_ theme: ThemeEnum) {
        switch theme {
        case .system:
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .unspecified
            }
        case .dark:
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
        case .light:
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
        }
    }
}
