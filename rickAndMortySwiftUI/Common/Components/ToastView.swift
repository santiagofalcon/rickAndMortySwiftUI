//
//  ToastView.swift
//  rickAndMortySwiftUI
//
//  Created by Santiago Falcon Gonzalez on 19/11/25.
//

import Foundation
import SwiftUI

struct ToastView: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.callout)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.ultraThickMaterial)
            .cornerRadius(16)
            .shadow(radius: 10)
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .animation(.spring(), value: message)
    }
}

struct ToastModifier: ViewModifier {
    @Binding var message: String?

    func body(content: Content) -> some View {
        ZStack {
            content

            if let msg = message {
                VStack {
                    Spacer()
                    ToastView(message: msg)
                        .padding(.bottom, 40)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            message = nil
                        }
                    }
                }
            }
        }
    }
}

extension View {
    func toast(message: Binding<String?>) -> some View {
        self.modifier(ToastModifier(message: message))
    }
}
