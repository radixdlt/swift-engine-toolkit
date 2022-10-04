//
//  AppTXApp.swift
//  AppTX
//
//  Created by Alexander Cyon on 2022-10-04.
//

import SwiftUI

@main
struct AppTXApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            #if os(macOS)
                .frame(minWidth: 600, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
            #endif
        }
    }
}
