//
//  EnvironmentValues+.swift
//  Grouping
//
//  Created by J_Min on 2023/07/27.
//

import SwiftUI

extension EnvironmentValues {
    var dismissHear: Binding<DismissHear> {
        get { return self[DismissHearModeKey.self] }
        set { self[DismissHearModeKey.self] = newValue }
    }
}

struct DismissHearModeKey: EnvironmentKey {
    static let defaultValue: Binding<DismissHear> = .constant(DismissHear())
}

typealias DismissHear = Bool

