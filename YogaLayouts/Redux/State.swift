//
//  State.swift
//  YogaLayouts
//
//  Created by Mwai Banda on 9/6/22.
//

import Foundation
import ReSwift

struct AppState: StateType {
    var content = ContentData()
    var isTabBarExpanded = false
}


struct ContentData {
    var tableContent = [String]()
    var topMenuOptions = [TopMenuOption]()
}
