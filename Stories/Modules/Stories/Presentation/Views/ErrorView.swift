//
//  ErrorView.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

import SwiftUI

struct ErrorView: View {

    let errorTitle: String
    let errorDescription: String
    let retryAction: () -> Void

    var body: some View {
        VStack {
            Image(systemName: Constants.errorImage)
                .foregroundColor(.gray)
                .padding(5)
            Text(errorTitle)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .padding(5)
            Text(errorDescription)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(5)
            Button(Constants.retry) {
                retryAction()
            }
            .bold()
        }
        .padding(50)
        .animation(.easeInOut, value: 0.5)
        .preferredColorScheme(.light)
    }
}
