//
//  InfoChip.swift
//  MyApp
//
//  Created by Hanin on 30/05/1448 AH.
//

import SwiftUI

struct InfoChip: View {
    let icon: String                // sun.max أو drop
    let text: String                // "Full sun" أو "20-50 ml"
    var font: Font = .chipLight     // خط الإضاءة (افتراضي)
    var color: Color = .chipText    // لون الإضاءة (افتراضي)

    var body: some View {
        HStack(spacing: 4) {                      // الأيقونة جنب النص
            Image(systemName: icon)
            Text(text)
        }
        .font(font)
        .foregroundColor(color)                   // ← هنا التغيير
        .padding(.horizontal, 8)
        .frame(height: AppLayout.chipHeight)      // 23
        .background(Color.chipBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppLayout.chipRadius))   // 8
    }
}

#Preview {
    HStack(spacing: 12) {
        InfoChip(icon: AppIcons.light, text: "Full sun")
        InfoChip(icon: AppIcons.water, text: "20-50 ml",
                 font: .chipWater, color: .chipWaterText)   // ← الماء سماوي
    }
    .padding()
    .background(Color.appBackground)
}
