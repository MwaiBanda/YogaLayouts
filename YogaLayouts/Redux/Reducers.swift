//
//  Reducers.swift
//  YogaLayouts
//
//  Created by Mwai Banda on 9/6/22.
//

import Foundation
import ReSwift

func mainAppReducer(action: Action, state: AppState?) -> AppState {
    AppState(tableContent: tableContentReducer(action: action, state: state))
}


func tableContentReducer(action: Action, state: AppState?) -> [String] {
    var state = state?.tableContent ?? []
    if case let content as NewTableContent = action {
        state = content.data
    }
    return state
}
