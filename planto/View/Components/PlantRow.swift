//
//  PlantRow.swift
//  PlanTo
//
//  صف نبتة واحدة في القائمة الرئيسية (شاشة Today Reminder في Sketch):
//  الدائرة ○ ✓، والغرفة، واسم النبتة، وشارتين الإضاءة والماء.
//

import SwiftUI

struct PlantRow: View {
    let plant: Plant                 // النبتة اللي نعرضها
    let onToggle: () -> Void         // وش يصير لما تنضغط الدائرة (الـ ViewModel يقرر)

    var body: some View {
        // HStack = جنب بعض: الدائرة يسار، والمعلومات يمين
        HStack(alignment: .center, spacing: 22) {

            // ---- الدائرة ○ / ✓ ----
            Button(action: onToggle) {
                ZStack {
                    if plant.isWatered {
                        // انسقت: دائرة خضرا وفيها ✓ سودا (من Sketch)
                        Circle().fill(Color.checkGreen)
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.black)
                    } else {
                        // ما انسقت: دائرة فاضية بحد رمادي
                        Circle().stroke(Color.uncheckedBorder,
                                        lineWidth: AppLayout.checkBorderWidth)   // 1.2
                    }
                }
                .frame(width: AppLayout.checkCircleSize,
                       height: AppLayout.checkCircleSize)                         // 23 × 23
            }
            .buttonStyle(.plain)   // عشان الزر ما ياخذ لون أزرق افتراضي

            // ---- المعلومات ----
            // VStack = فوق بعض: الغرفة، ثم الاسم، ثم الشارات
            VStack(alignment: .leading, spacing: 4) {

                // الغرفة: "in Kitchen" مع أيقونة السهم
                Label("in \(plant.room.rawValue)", systemImage: AppIcons.room)
                    .font(.plantRoom)
                    .foregroundColor(.textRoom)

                // اسم النبتة: يبهت إذا انسقت (من Sketch: #989898)
                Text(plant.name)
                    .font(.plantName)
                    .foregroundColor(plant.isWatered ? Color(hex: "989898") : .textPrimary)

                // الشارتين جنب بعض
                HStack(spacing: 12) {
                    InfoChip(icon: plant.light.icon,
                             text: plant.light.rawValue)
                    InfoChip(icon: AppIcons.water,
                             text: plant.waterAmount.rawValue,
                             font: .chipWater,
                             color: .chipWaterText)
                }
            }

            Spacer()   // يدفع كل شي لليسار
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        // الخط الرفيع تحت كل صف
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.rowDivider)
                .frame(height: 1)
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        PlantRow(plant: Plant.samples[0]) { }   // ما انسقت
        PlantRow(plant: Plant.samples[2]) { }   // انسقت
    }
    .background(Color.appBackground)
}
