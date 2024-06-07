//
//  UserSession.swift
//  Template
//
//  Created by Mateusz Bunkowski on 6/6/24.
//

import SwiftUI

final class UserSession: ObservableObject {
    
    private var onLogOut: (() -> Void)
    
    init(onLogOut: @escaping (() -> Void)) {
        self.onLogOut = onLogOut
    }
    
    func logOut() {
        onLogOut()
    }
}
