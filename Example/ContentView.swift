//
//  ContentView.swift
//  AppTX
//
//  Created by Alexander Cyon on 2022-10-04.
//

import SwiftUI
import TransactionKit

struct ContentView: View {
    var body: some View {
        VStack {
            Text(getInformation())
                .padding()
        }
        .padding()
    }
}

private extension ContentView {
    func getInformation() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
        let encoded_data: Data = try! encoder.encode(TX.information());
        let encoded_string: String = String(data: encoded_data, encoding: .utf8)!;
        return encoded_string
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
