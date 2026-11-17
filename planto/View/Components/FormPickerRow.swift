//
//  FormPickerRow.swift
//  PlanTo
//
//  صف واحد في فورم Set Reminder، مثل:   ➤ Room ................ Bedroom ⌃⌄
//  يشتغل مع أي قائمة خيارات من PlantOptions (Room, Light, WateringDays, WaterAmount)
//

import SwiftUI

// <Option> = "نوع عام": الصف ما يعرف مسبقاً هو غرف ولا إضاءة.
// الشروط بعد where = أي خيارات نعطيه لازم يكون لها نص (rawValue) ونقدر نجيبها كلها (allCases)
struct FormPickerRow<Option>: View
where Option: CaseIterable & Hashable & RawRepresentable,
      Option.RawValue == String,
      Option.AllCases: RandomAccessCollection {

    let title: String                  // "Room"
    let icon: String                   // "location"
    @Binding var selection: Option     // الخيار المختار. Binding = نعدّل نفس القيمة اللي في الفورم

    var body: some View {
        HStack {
            // العنوان مع الأيقونة (يسار)
            Label(title, systemImage: icon)
                .font(.formLabel)                  // 18 Regular
                .foregroundColor(.textPrimary)

            Spacer()

            // القيمة المختارة مع ⌃⌄ (يمين). لما تنضغط تطلع قائمة الخيارات
            Menu {
                Picker(title, selection: $selection) {
                    ForEach(Option.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Text(selection.rawValue)
                    Image(systemName: AppIcons.picker)   // chevron.up.chevron.down
                        .font(.system(size: 14))
                }
                .font(.formLabel)
                .foregroundColor(.textValue)             // رمادي #8E8E93
            }
        }
        .padding(.horizontal, 18)
        .frame(height: 47)                               // نص ارتفاع الخانة (95 ÷ 2)
    }
}

#Preview {
    @Previewable @State var room: Room = .bedroom
    FormPickerRow(title: "Room", icon: AppIcons.room, selection: $room)
        .background(Color.fieldBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppLayout.fieldRadius))
        .padding()
        .background(Color.sheetBackground)
}
