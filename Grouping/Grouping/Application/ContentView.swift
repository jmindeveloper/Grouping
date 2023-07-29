//
//  ContentView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/09.
//

import SwiftUI

struct ContentView: View {
    @State var showLoginVC: Bool = false
    
    var body: some View {
        
        MainTabView()
            .fullScreenCover(isPresented: $showLoginVC) {
                LazyView(
                    LoginMainView()
                )
            }
            .onAppear {
                UserAuthManager.shared.getUser() { isSuccess in
                    if !isSuccess {
                        showLoginVC = true
                    }
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
