//
//  Reducers.swift
//  YogaLayouts
//
//  Created by Mwai Banda on 9/6/22.
//

import Foundation
import ReSwift

func mainAppReducer(action: Action, state: AppState?) -> AppState {
    AppState(
        content: contentReducer(action: action, state: state),
        isTabBarExpanded: isTabBarExpandedReducer(action: action, state: state)
    )
}


func contentReducer(action: Action, state: AppState?) -> ContentData {
    var state = state?.content ?? ContentData()
    if case let content as NewContent = action {
        state = content.data
    }
    return state
}

func isTabBarExpandedReducer(action: Action, state: AppState?) -> Bool {
    var state = state?.isTabBarExpanded ?? false
    if case let content as SetTabBarState = action {
        state = content.state
    }
    return state
}
