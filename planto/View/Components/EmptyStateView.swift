//
//  EmptyStateView.swift
//  PlanTo
//
//  صورة النبتة + عنوان + وصف، في نص الشاشة.
//  نستخدمها في شاشتين من Sketch:
//   - "Start your plant journey!"  (صورة plantHappy)
//   - "All Done! 🎉"               (صورة plantWink مع دائرة غامقة وراها)
//

import SwiftUI

struct EmptyStateView: View {
    let imageName: String          // اسم الصورة في Assets
    let title: String              // العنوان الكبير
    let subtitle: String           // الوصف تحته
    var showsCircle: Bool = false  // دائرة غامقة ورا الصورة (في All Done بس)

    var body: some View {
        VStack(spacing: 0) {

            // الصورة
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 164, height: 200)            // مقاس الصورة في Sketch
                .background {
                    if showsCircle {
                        // الدائرة الغامقة ورا النبتة في شاشة All Done (من Sketch)
                        Circle()
                            .fill(Color(hex: "0C0C0F"))
                            .frame(width: 222, height: 222)
                    }
                }
                .padding(.bottom, 40)

            // العنوان
            Text(title)
                .font(.stateTitle)                         // 25 Semibold
                .foregroundColor(.textPrimary)
                .padding(.bottom, 12)

            // الوصف
            Text(subtitle)
                .font(.description)                        // 16 Regular
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)           // النص في النص
                .padding(.horizontal, 50)
        }
    }
}

#Preview {
    EmptyStateView(imageName: "plantHappy",
                   title: "Start your plant journey!",
                   subtitle: "Now all your plants will be in one place and we will help you take care of them :) 🪴")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
}
