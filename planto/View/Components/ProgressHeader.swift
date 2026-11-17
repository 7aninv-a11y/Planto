//
//  ProgressHeader.swift
//  PlanTo
//
//  الجملة وشريط التقدم فوق القائمة (شاشة Today Reminder في Sketch).
//

import SwiftUI

struct ProgressHeader: View {
    let text: String         // الجملة: "Your plants are waiting for a sip 💦" ...
    let progress: Double     // كم يتعبى الشريط: من 0 إلى 1 (يجي من الـ ViewModel)

    var body: some View {
        VStack(spacing: 16) {

            // الجملة
            Text(text)
                .font(.progressText)
                .foregroundColor(.textPrimary)

            // الشريط
            // GeometryReader = يعطينا عرض المساحة المتاحة، عشان نحسب عرض الجزء الأخضر
            GeometryReader { geo in
                // ZStack(alignment: .leading) = فوق بعض، ومن جهة اليسار
                ZStack(alignment: .leading) {

                    // الخلفية الرمادية (الشريط كامل)
                    Capsule()
                        .fill(Color.progressTrack)

                    // الجزء الأخضر: عرضه = العرض الكامل × التقدم
                    Capsule()
                        .fill(Color.primaryGreen)
                        .frame(width: geo.size.width * progress)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)   // ظل Sketch
                }
            }
            .frame(width: AppLayout.progressWidth,       // 361
                   height: AppLayout.progressHeight)     // 8
            // أنيميشن: لما يتغير التقدم، الشريط يتعبى بنعومة بدل ما يقفز
            .animation(.easeInOut(duration: 0.4), value: progress)
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        ProgressHeader(text: "Your plants are waiting for a sip 💦", progress: 0)
        ProgressHeader(text: "3 of your plants feel loved today✨", progress: 0.75)
    }
    .padding()
    .background(Color.appBackground)
}
