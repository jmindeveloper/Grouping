//
//  EnvironmentValues+.swift
//  Grouping
//
//  Created by J_Min on 2023/07/27.
//

import SwiftUI

extension EnvironmentValues {
    var rootPresentationMode: Binding<RootPresentationMode> {
        get { return self[RootPresentationModeKey.self] }
        set { self[RootPresentationModeKey.self] = newValue }
    }
    
    var dismissHear: Binding<DismissHear> {
        get { return self[DismissHearModeKey.self] }
        set { self[DismissHearModeKey.self] = newValue }
    }
}

struct RootPresentationModeKey: EnvironmentKey {
    static let defaultValue: Binding<RootPresentationMode> = .constant(RootPresentationMode())
}

typealias RootPresentationMode = Bool

struct DismissHearModeKey: EnvironmentKey {
    static let defaultValue: Binding<DismissHear> = .constant(DismissHear())
}

typealias DismissHear = Bool

