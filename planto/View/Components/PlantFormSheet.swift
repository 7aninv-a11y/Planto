//
//  PlantFormSheet.swift
//  PlanTo
//
//  فورم Set Reminder (Sheet). نفس الفورم لشغلتين (من Sketch):
//   - إضافة نبتة جديدة          ← شاشة "Set Reminder"
//   - تعديل نبتة + زر الحذف     ← شاشة "Delete / EDIT Plant"
//

import SwiftUI

struct PlantFormSheet: View {

    // ---- اللي يجي من برا ----
    let plantToEdit: Plant?                 // nil = نبتة جديدة،  غير كذا = نعدّل هالنبتة
    let onSave: (Plant) -> Void             // وش يصير لما نضغط ✓
    var onDelete: (() -> Void)? = nil       // وش يصير لما نضغط Delete Reminder (في التعديل بس)

    // dismiss = نسكّر الـ Sheet
    @Environment(\.dismiss) private var dismiss

    // ---- اللي يكتبه ويختاره المستخدم ----
    // @State = معلومات تعيش داخل الفورم بس (ما نحتاج ViewModel لها، لأنها بسيطة)
    @State private var name = ""
    @State private var room: Room = .bedroom
    @State private var light: Light = .fullSun
    @State private var wateringDays: WateringDays = .everyDay
    @State private var waterAmount: WaterAmount = .ml20to50

    // هل نحن نعدّل؟
    private var isEditing: Bool { plantToEdit != nil }

    // التحقق: زر ✓ يشتغل بس إذا الاسم مو فاضي (بعد ما نشيل المسافات)
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            navBar                          // X  ·  Set Reminder  ·  ✓
                .padding(.top, 15)
                .padding(.bottom, 45)

            VStack(spacing: 50) {
                nameField                   // Plant Name
                roomLightGroup              // Room + Light
                wateringGroup               // Watering Days + Water

                if isEditing {
                    deleteButton            // Delete Reminder (في التعديل بس)
                }
            }
            .padding(.horizontal, 17)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.sheetBackground)
        // أول ما يفتح الفورم: إذا نعدّل، نعبّي الخانات بمعلومات النبتة
        .onAppear(perform: fillFields)
    }


    // MARK: - الشريط اللي فوق

    private var navBar: some View {
        HStack {
            CircleButton(icon: AppIcons.close, style: .dark) {
                dismiss()                               // X = سكّر بدون حفظ
            }

            Spacer()

            Text("Set Reminder")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.textPrimary)

            Spacer()

            CircleButton(icon: AppIcons.check) {
                save()                                  // ✓ = احفظ وسكّر
            }
            .disabled(!canSave)                         // ما ينضغط إذا الاسم فاضي
            .opacity(canSave ? 1 : 0.4)                 // ويبهت
        }
        .padding(.horizontal, 30)
    }


    // MARK: - خانة الاسم

    private var nameField: some View {
        HStack(spacing: 10) {
            Text("Plant Name")
                .font(.formLabel)
                .foregroundColor(.textPrimary)

            // TextField = خانة كتابة. $name = اللي ينكتب يروح لمتغير name
            TextField("", text: $name,
                      prompt: Text("Pothos").foregroundColor(.textPlaceholder))   // placeholder رمادي
                .font(.formPlaceholder)
                .foregroundColor(.textPrimary)
                .tint(.checkGreen)                       // لون المؤشر الأخضر (من Sketch)
        }
        .padding(.horizontal, 20)
        .frame(height: AppLayout.nameFieldHeight)        // 62
        .background(Color.fieldBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppLayout.fieldRadius))   // 30
    }


    // MARK: - Room + Light

    private var roomLightGroup: some View {
        VStack(spacing: 0) {
            FormPickerRow(title: "Room",  icon: AppIcons.room,  selection: $room)
            divider
            FormPickerRow(title: "Light", icon: AppIcons.light, selection: $light)
        }
        .background(Color.fieldBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppLayout.fieldRadius))
    }


    // MARK: - Watering Days + Water

    private var wateringGroup: some View {
        VStack(spacing: 0) {
            FormPickerRow(title: "Watering Days", icon: AppIcons.water, selection: $wateringDays)
            divider
            FormPickerRow(title: "Water",         icon: AppIcons.water, selection: $waterAmount)
        }
        .background(Color.fieldBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppLayout.fieldRadius))
    }

    // الخط بين الصفين
    private var divider: some View {
        Rectangle()
            .fill(Color.fieldDivider)
            .frame(height: 1)
            .padding(.horizontal, 10)
    }


    // MARK: - زر الحذف

    private var deleteButton: some View {
        Button {
            onDelete?()                                  // نبلغ الشاشة الرئيسية تحذف
            dismiss()
        } label: {
            Text("Delete Reminder")
                .font(.formLabel)
                .foregroundColor(.destructiveRed)
                .frame(maxWidth: .infinity)
                .frame(height: AppLayout.deleteRowHeight)            // 52
                .background(Color.fieldBackground)
                .clipShape(RoundedRectangle(cornerRadius: AppLayout.deleteRowRadius))   // 26
        }
        .padding(.horizontal, 7)                         // أضيق شوي من باقي الخانات (370 بدل 388)
    }


    // MARK: - أفعال

    // نعبّي الخانات بمعلومات النبتة اللي نعدلها
    private func fillFields() {
        guard let plant = plantToEdit else { return }    // إذا جديدة، نخليها فاضية
        name         = plant.name
        room         = plant.room
        light        = plant.light
        wateringDays = plant.wateringDays
        waterAmount  = plant.waterAmount
    }

    // نجهز النبتة ونرسلها للشاشة الرئيسية
    private func save() {
        // إذا نعدّل: نبدأ من النبتة القديمة (عشان يظل نفس الـ id)
        // إذا جديدة: نسوي نبتة جديدة
        var plant = plantToEdit ?? Plant(name: name, room: room, light: light,
                                         wateringDays: wateringDays, waterAmount: waterAmount)
        plant.name         = name.trimmingCharacters(in: .whitespaces)
        plant.room         = room
        plant.light        = light
        plant.wateringDays = wateringDays
        plant.waterAmount  = waterAmount

        onSave(plant)                                    // نرسلها
        dismiss()                                        // ونسكّر
    }
}

#Preview("Add") {
    PlantFormSheet(plantToEdit: nil) { _ in }
}

#Preview("Edit") {
    PlantFormSheet(plantToEdit: Plant.samples[1], onSave: { _ in }, onDelete: { })
}
