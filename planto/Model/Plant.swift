//
//  Plant.swift
//  PlanTo
//
//  النبتة نفسها: كل المعلومات اللي يدخلها المستخدم في فورم Set Reminder،
//  وهل انسقت اليوم (الدائرة اللي يشيّك عليها في القائمة).
//

import Foundation   // نحتاجها عشان UUID


// struct       = "قالب" لشي فيه معلومات (مثل بطاقة تعريف للنبتة)
// Identifiable = كل نبتة لها رقم مميز (id) عشان SwiftUI يفرّق بينها في القائمة
// Codable      = نقدر نحفظ النبتة في الجوال ونرجعها
struct Plant: Identifiable, Codable {

    // رقم مميز لكل نبتة، يتولد تلقائياً وما يتكرر أبداً
    // (حتى لو فيه نبتتين بنفس الاسم، كل وحدة لها id مختلف)
    var id = UUID()

    // ---- المعلومات اللي يدخلها المستخدم في الفورم (من Sketch) ----

    var name: String                 // Plant Name        مثال: "Pothos"
    var room: Room                   // Room              مثال: .bedroom
    var light: Light                 // Light             مثال: .fullSun
    var wateringDays: WateringDays   // Watering Days     مثال: .everyDay
    var waterAmount: WaterAmount     // Water             مثال: .ml20to50

    // ---- حالة السقي ----

    // false = الدائرة فاضية ○  (ما انسقت)
    // true  = الدائرة خضرا ✓  (انسقت، والصف يبهت)
    var isWatered: Bool = false      // كل نبتة جديدة تبدأ "ما انسقت"
}


// MARK: - بيانات تجريبية
// نبتات مثل اللي في Sketch، نستخدمها في الـ Preview بس عشان نشوف الشكل
// (ما تنحفظ في التطبيق الحقيقي)
extension Plant {
    static let samples: [Plant] = [
        Plant(name: "Monstera", room: .kitchen,    light: .fullSun, wateringDays: .everyDay, waterAmount: .ml20to50),
        Plant(name: "Pothos",   room: .bedroom,    light: .fullSun, wateringDays: .everyDay, waterAmount: .ml20to50),
        Plant(name: "Orchid",   room: .livingRoom, light: .fullSun, wateringDays: .everyDay, waterAmount: .ml20to50, isWatered: true),
        Plant(name: "Spider",   room: .kitchen,    light: .fullSun, wateringDays: .everyDay, waterAmount: .ml20to50, isWatered: true)
    ]
}
