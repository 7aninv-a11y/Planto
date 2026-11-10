//
//  PlantsViewModel.swift
//  PlanTo
//
//  "الطباخ": يضيف النباتات ويعدلها ويحذفها، ويشيّك عليها، ويحسب التقدم،
//  ويقرر أي حالة تظهر في الشاشة الرئيسية. ما يرسم أي شي على الشاشة.
//

import Foundation   // للأشياء الأساسية
import Observation  // عشان @Observable


// MARK: - حالات الشاشة الرئيسية (من Sketch)

enum HomeState {
    case empty      // ما فيه نباتات      ← شاشة "Start your plant journey!"
    case list       // فيه نباتات          ← شاشة "Today Reminder"
    case allDone    // كل النباتات انسقت   ← شاشة "All Done! 🎉"
}


// MARK: - الـ ViewModel

// @Observable = أي تغيير هنا، الشاشات اللي تستخدمه تتحدث تلقائياً
// (مثلاً: لما نشيّك على نبتة، الشريط والقائمة يتغيرون بدون ما نقول لهم)
@Observable
final class PlantsViewModel {

    // قائمة كل النباتات. هي "مصدر الحقيقة": أي شاشة تبي النباتات تاخذها من هنا
    // private(set) = الشاشات تقدر تقراها، بس ما تقدر تغيرها مباشرة.
    //                التغيير لازم يمر عن طريق الدوال تحت (add, edit, delete...)
    private(set) var plants: [Plant] = []

    // المخزن اللي نحفظ فيه. نوعه "الاتفاقية" مو مخزن معين
    // (عشان نقدر نعطيه الحقيقي في التطبيق، والتجريبي في الـ Preview)
    private let store: PlantStoring

    // init = أول ما ينولد الـ ViewModel
    // "= UserDefaultsPlantStore()" = إذا ما عطيناه مخزن، ياخذ الحقيقي تلقائياً
    init(store: PlantStoring = UserDefaultsPlantStore()) {
        self.store = store
        self.plants = store.load()     // نقرأ النباتات المحفوظة من الجوال
    }


    // MARK: - حسابات للشاشة

    // كم نبتة انسقت
    var wateredCount: Int {
        plants.filter { $0.isWatered }.count     // نعد النباتات اللي isWatered = true
    }

    // كم يتعبى الشريط الأخضر: رقم من 0 إلى 1 (مثال: 3 من 4 = 0.75)
    var progress: Double {
        guard !plants.isEmpty else { return 0 }  // إذا ما فيه نباتات، لا نقسم على صفر
        return Double(wateredCount) / Double(plants.count)
    }

    // الجملة فوق الشريط، نفس نصوص Sketch بالضبط
    var progressText: String {
        if wateredCount == 0 {
            return "Your plants are waiting for a sip 💦"
        } else {
            return "\(wateredCount) of your plants feel loved today✨"
        }
    }

    // ترتيب القائمة: اللي ما انسقت فوق، واللي انسقت تنزل تحت (مثل Sketch)
    var sortedPlants: [Plant] {
        plants.filter { !$0.isWatered } + plants.filter { $0.isWatered }
    }

    // أي حالة تظهر في الشاشة الرئيسية
    var state: HomeState {
        if plants.isEmpty {
            return .empty                         // ما فيه نباتات
        } else if wateredCount == plants.count {
            return .allDone                       // كلها انسقت
        } else {
            return .list                          // فيه نباتات ما انسقت
        }
    }


    // MARK: - أوامر (الشاشات تطلبها، والـ ViewModel ينفذها)

    // إضافة نبتة جديدة (زر ✓ في الفورم)
    func add(_ plant: Plant) {
        plants.append(plant)          // نضيفها للقائمة
        save()                        // ونحفظ
    }

    // تعديل نبتة موجودة (الفورم بوضع التعديل)
    func edit(_ plant: Plant) {
        // نلقى مكان النبتة في القائمة عن طريق الـ id
        guard let index = plants.firstIndex(where: { $0.id == plant.id }) else { return }
        plants[index] = plant         // نبدلها بالنسخة المعدلة
        save()
    }

    // حذف نبتة (الـ swipe، أو زر Delete Reminder)
    func delete(_ plant: Plant) {
        plants.removeAll { $0.id == plant.id }   // نشيل النبتة اللي لها نفس الـ id
        save()
    }

    // تشييك / إلغاء تشييك (الدائرة ○ ✓ في الصف)
    func toggleWatered(_ plant: Plant) {
        guard let index = plants.firstIndex(where: { $0.id == plant.id }) else { return }
        plants[index].isWatered.toggle()   // toggle = يقلبها: false ← → true
        save()
    }


    // MARK: - داخلي

    // نحفظ القائمة كلها في الجوال بعد أي تغيير
    private func save() {
        store.save(plants)
    }
}
