//
//  SkeletonView.swift
//  rickAndMortySwiftUI
//
//  Created by Santiago Falcon Gonzalez on 19/11/25.
//

import Foundation
import SwiftUI

struct ShimmerView: View {
    @State private var phase: CGFloat = 0

    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemGray5),
                        Color.white.opacity(0.6),
                        Color(.systemGray5)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .mask(
                Rectangle()
                    .fill(Color.white)
                    .blur(radius: 8)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

struct SkeletonRow: View {
    var body: some View {
        HStack(spacing: 16) {
            ShimmerView()
                .frame(width: 64, height: 64)
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 8) {
                ShimmerView().frame(height: 18).cornerRadius(8)
                ShimmerView().frame(width: 120, height: 14).cornerRadius(8)
            }

            Spacer()
        }
        .padding(.vertical, 6)
    }
}
