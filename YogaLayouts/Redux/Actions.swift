//
//  Actions.swift
//  YogaLayouts
//
//  Created by Mwai Banda on 9/6/22.
//

import Foundation
import ReSwift

struct NewTableContent: Action {
    let data: [String]
}

func getData(
    _ state: AppState,
    _ store: Store<AppState>,
    _ actionCreatorCallback: @escaping ((Store<AppState>.ActionCreator) -> Void)
) {
    actionCreatorCallback{ state,store -> Action in NewTableContent(data: Array(repeating: "This is content", count: 25)) }
}
