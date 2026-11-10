//  PlantOptions.swift
//  PlanTo
//
//  خيارات فورم Set Reminder الأربعة، كلها مأخوذة من Sketch (frame "The content").
//

import Foundation   // مكتبة Apple الأساسية (نحتاجها للنصوص والحفظ)


// MARK: - Room (الغرفة)

// enum         = قائمة خيارات ثابتة، ما يقبل غيرها
// String       = كل خيار له نص يظهر للمستخدم
// CaseIterable = نقدر نجيب كل الخيارات مرة وحدة (نحتاجه للـ Picker)
// Codable      = نقدر نحفظه في الجوال (نحتاجه للحفظ)
enum Room: String, CaseIterable, Codable {
    case bedroom    = "Bedroom"       // الاسم داخل الكود = النص اللي يشوفه المستخدم
    case livingRoom = "Living Room"
    case kitchen    = "Kitchen"
    case balcony    = "Balcony"
    case bathroom   = "Bathroom"
}


// MARK: - Light (الإضاءة)

enum Light: String, CaseIterable, Codable {
    case fullSun    = "Full Sun"
    case partialSun = "Partial Sun"
    case lowLight   = "Low Light"

    // var icon = معلومة نحسبها لكل خيار
    // ترجع اسم أيقونة SF Symbol اللي تطلع جنب الخيار في Sketch
    var icon: String {
        switch self {                          // self = الخيار الحالي
        case .fullSun:    return "sun.max"     // شمس كاملة
        case .partialSun: return "sun.haze"    // شمس مع خطوط تحتها
        case .lowLight:   return "moon"        // قمر
        }
    }
}


// MARK: - Watering Days (أيام السقي)

enum WateringDays: String, CaseIterable, Codable {
    case everyDay     = "Every day"        // كل يوم
    case every2Days   = "Every 2 days"     // كل يومين
    case every3Days   = "Every 3 days"     // كل ٣ أيام
    case onceAWeek    = "Once a week"      // مرة في الأسبوع
    case every10Days  = "Every 10 days"    // كل ١٠ أيام
    case every2Weeks  = "Every 2 weeks"    // كل أسبوعين
}


// MARK: - Water Amount (كمية الماء)

enum WaterAmount: String, CaseIterable, Codable {
    case ml20to50    = "20-50 ml"
    case ml50to100   = "50-100 ml"
    case ml100to200  = "100-200 ml"
    case ml200to300  = "200-300 ml"
}
