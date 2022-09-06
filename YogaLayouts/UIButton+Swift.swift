//
//  UIButton+Swift.swift
//  YogaLayouts
//
//  Created by Mwai Banda on 9/4/22.
//

import UIKit


extension UIButton {
    struct OptionHolder {
        static var storedOptions = [TopMenuOption]()
    }
    var menuOptions: [TopMenuOption] {
        get {
            return OptionHolder.storedOptions
        }
        set(newValue) {
            OptionHolder.storedOptions.append(contentsOf: newValue)
        }
    }
}
