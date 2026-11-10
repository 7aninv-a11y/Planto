//
//  PrimaryButton.swift
//  MyApp
//
//  Created by Hanin on 30/05/1448 AH.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    private let glassColor = Color(hex: "9BE8D1")   // نفس زجاج CircleButton

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.white)
                .frame(width: AppLayout.primaryButtonWidth,      // 280
                       height: AppLayout.primaryButtonHeight)    // 42
                .background(
                    Capsule()
                        .fill(Color.primaryGreen)
                        .overlay(
                            Capsule().strokeBorder(glassEdge, lineWidth: 1.25)
                        )
                )
        }
    }

    private var glassEdge: LinearGradient {
        LinearGradient(stops: [
            .init(color: glassColor,               location: 0.0),
            .init(color: glassColor.opacity(0.25), location: 0.35),
            .init(color: glassColor.opacity(0.25), location: 0.65),
            .init(color: glassColor,               location: 1.0)
        ], startPoint: .top, endPoint: .bottom)
    }
}

#Preview {
    PrimaryButton(title: "Set Plant Reminder") { }
        .padding()
        .background(Color.appBackground)
}
