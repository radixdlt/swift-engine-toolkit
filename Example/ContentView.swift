//
//  ContentView.swift
//  AppTX
//
//  Created by Alexander Cyon on 2022-10-04.
//

import EngineToolkit
import SwiftUI

struct ContentView: View {
    @State var information = ""
    var body: some View {
        VStack {
            Text(information)
                .padding()
        }
        .onAppear {
            do {
                information = try getInformation()
            } catch {
                information = "❗️⚠️ Failed to get information, error: \(error)"
            }
        }
        .padding()
    }
}

private extension ContentView {
    func getInformation() throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
        let information = try EngineToolkit().information().get()
        let encoded_data: Data = try encoder.encode(information)
        let encoded_string = String(data: encoded_data, encoding: .utf8)!
        return encoded_string
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
