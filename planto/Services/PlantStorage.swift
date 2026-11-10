//
//  PlantStorage.swift
//  PlanTo
//
//  حفظ النباتات داخل الجوال، عشان ما تروح لما المستخدم يسكّر التطبيق ويفتحه.
//  (ما فيه سيرفر ولا إنترنت، كل شي ينحفظ في الجوال نفسه)
//

import Foundation   // نحتاجها عشان UserDefaults و JSON


// MARK: - الاتفاقية (Protocol)

// protocol = "اتفاقية" تقول: أي شي يبي يصير مخزن للنباتات، لازم يعرف يسوي هالشيئين.
// الـ ViewModel بيتعامل مع هالاتفاقية بس، وما يهمه كيف ينحفظ من الداخل.
// (هذا مبدأ D من SOLID: نعتمد على اتفاقية، مو على طريقة حفظ معينة)
protocol PlantStoring {
    func load() -> [Plant]           // يرجّع كل النباتات المحفوظة
    func save(_ plants: [Plant])     // يحفظ كل النباتات
}


// MARK: - الحفظ في الجوال (UserDefaults)

// UserDefaults = مكان صغير داخل الجوال يحفظ معلومات بسيطة للتطبيق.
// النباتات قليلة، فهو يكفي ومناسب.
struct UserDefaultsPlantStore: PlantStoring {   // ": PlantStoring" = يلتزم بالاتفاقية فوق

    // "المفتاح" = اسم الدرج اللي نحط فيه النباتات داخل UserDefaults
    private let key = "savedPlants"

    // ---- قراءة النباتات ----
    func load() -> [Plant] {
        // ١) نطلع البيانات من الدرج. إذا ما فيه شي (أول مرة)، نرجّع قائمة فاضية
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }

        // ٢) نحوّل البيانات من JSON إلى نباتات (هنا يفيدنا Codable)
        //    "try?" = جرّب، وإذا صار خطأ رجّع nil بدل ما يطيح التطبيق
        let plants = try? JSONDecoder().decode([Plant].self, from: data)

        // ٣) نرجّع النباتات، وإذا صار خطأ نرجّع قائمة فاضية
        return plants ?? []
    }

    // ---- حفظ النباتات ----
    func save(_ plants: [Plant]) {
        // ١) نحوّل النباتات إلى JSON (بيانات نقدر نحفظها)
        guard let data = try? JSONEncoder().encode(plants) else {
            return   // إذا صار خطأ في التحويل، نوقف وما نحفظ
        }

        // ٢) نحط البيانات في الدرج
        UserDefaults.standard.set(data, forKey: key)
    }
}


// MARK: - مخزن تجريبي (للـ Preview بس)

// نفس الاتفاقية، بس ما يحفظ شي فعلياً.
// نستخدمه في الـ Preview عشان نشوف الشاشات بالنباتات التجريبية
// بدون ما نلمس البيانات الحقيقية في الجوال.
struct PreviewPlantStore: PlantStoring {
    var plants: [Plant] = Plant.samples          // النباتات التجريبية من Plant.swift

    func load() -> [Plant] { plants }            // يرجّع النباتات التجريبية
    func save(_ plants: [Plant]) { }             // ما يسوي شي
}
