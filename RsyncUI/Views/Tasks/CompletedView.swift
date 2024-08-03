//
//  CompletedView.swift
//  RsyncUI
//
//  Created by Thomas Evensen on 20/05/2024.
//

import SwiftUI

struct CompletedView: View {
    @Binding var path: [Tasks]

    var body: some View {
        Text("Synchronize data is completed")
            .font(.title2)
            .onAppear(perform: {
                Task {
                    try await Task.sleep(seconds: 0.5)
                    path.removeAll()
                }
            })
    }
}
