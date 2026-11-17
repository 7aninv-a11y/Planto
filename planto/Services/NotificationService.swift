//
//  NotificationService.swift
//  PlanTo
//
//  الإشعارات المحلية (من الجوال نفسه، بدون إنترنت).
//  نص الإشعار من Sketch:   Planto
//                          Hey! let's water your plant
//
//  ⚠️ الفرق بين "الحفظ" و"الإشعار":
//    - الحفظ (PlantStorage): يحفظ معلومات النبتة في الجوال
//    - الإشعار (هنا):        يطلب من iPhone يرسل تنبيه في وقت معين
//    هم شيئين منفصلين، فلما نحذف نبتة لازم نلغي إشعارها بعد.
//

import Foundation
import UserNotifications   // مكتبة Apple للإشعارات


// MARK: - الاتفاقية (نفس فكرة PlantStoring)

protocol NotificationScheduling {
    func requestPermission()           // نطلب إذن المستخدم مرة وحدة
    func schedule(for plant: Plant)    // نجدول (أو نحدّث) إشعار نبتة
    func cancel(for plant: Plant)      // نلغي إشعار نبتة
}


// MARK: - كل كم يوم نذكّر (من Watering Days)

extension WateringDays {
    var days: Int {
        switch self {
        case .everyDay:    return 1
        case .every2Days:  return 2
        case .every3Days:  return 3
        case .onceAWeek:   return 7
        case .every10Days: return 10
        case .every2Weeks: return 14
        }
    }
}


// MARK: - الإشعارات الحقيقية

// NSObject + UNUserNotificationCenterDelegate = عشان الإشعار يطلع حتى لو التطبيق مفتوح
final class LocalNotificationService: NSObject, NotificationScheduling, UNUserNotificationCenterDelegate {

    private let center = UNUserNotificationCenter.current()   // "مركز الإشعارات" في الجوال

    // ⚠️ Sketch ما فيه اختيار وقت، فحطينا ساعة ثابتة.
    //    غيريها هنا إذا تبين وقت ثاني (9 = الساعة 9 الصبح)
    private let reminderHour = 9

    override init() {
        super.init()
        center.delegate = self        // نخلي هالكلاس هو اللي يتعامل مع الإشعارات
    }

    // ---- طلب الإذن ----
    // أول مرة بس: يطلع للمستخدم "PlanTo يبي يرسل لك إشعارات" (Allow / Don't Allow)
    func requestPermission() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    // ---- جدولة إشعار نبتة ----
    func schedule(for plant: Plant) {
        // ١) نلغي أي إشعار قديم لنفس النبتة (مهم لما نعدّل)
        cancel(for: plant)

        // ٢) محتوى الإشعار (نفس نص Sketch)
        let content = UNMutableNotificationContent()
        content.title = "Planto"
        content.body  = "Hey! let's water your plant"
        content.sound = .default

        // ٣) متى يطلع؟
        let trigger: UNNotificationTrigger
        if plant.wateringDays == .everyDay {
            // كل يوم الساعة 9
            var time = DateComponents()
            time.hour = reminderHour
            trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)
        } else {
            // كل X يوم (يومين، ٣ أيام، أسبوع...)
            let seconds = TimeInterval(plant.wateringDays.days * 24 * 60 * 60)
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: true)
        }

        // ٤) نرسل الطلب للجوال
        //    identifier = id النبتة، عشان نعرف نلغي إشعارها بالذات بعدين
        let request = UNNotificationRequest(identifier: plant.id.uuidString,
                                            content: content,
                                            trigger: trigger)
        center.add(request)
    }

    // ---- إلغاء إشعار نبتة ----
    func cancel(for plant: Plant) {
        center.removePendingNotificationRequests(withIdentifiers: [plant.id.uuidString])
    }

    // ---- للتجربة بس: إشعار بعد 5 ثواني ----
    // ناديها مرة من أي مكان، وسكّري التطبيق (أو خليه مفتوح) وانتظري 5 ثواني
    func sendTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Planto"
        content.body  = "Hey! let's water your plant"
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        center.add(UNNotificationRequest(identifier: "test", content: content, trigger: trigger))
    }

    // ---- يخلي الإشعار يطلع حتى لو التطبيق مفتوح قدامك ----
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
                                -> UNNotificationPresentationOptions {
        [.banner, .sound]
    }
}


// MARK: - إشعارات تجريبية (للـ Preview بس، ما تسوي شي)

struct PreviewNotificationService: NotificationScheduling {
    func requestPermission() { }
    func schedule(for plant: Plant) { }
    func cancel(for plant: Plant) { }
}
