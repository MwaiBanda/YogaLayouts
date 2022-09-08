//
//  Actions.swift
//  YogaLayouts
//
//  Created by Mwai Banda on 9/6/22.
//

import Foundation
import ReSwift

struct NewContent: Action {
    let data: ContentData
}

struct SetTabBarState: Action {
    let state: Bool
}

func getData(
    _ state: AppState,
    _ store: Store<AppState>,
    _ actionCreatorCallback: @escaping ((Store<AppState>.ActionCreator) -> Void)
) {
    actionCreatorCallback{ state,store -> Action in NewContent(
        data: ContentData(
            tableContent: Array(repeating: "This is content", count: 25),
            topMenuOptions: [
                .topNews,
                .us,
                .world,
                .insideIsrael,
                .nationalSecurity,
                .politics,
                .entertainment,
                .health
            ]
        )
    )}
}

