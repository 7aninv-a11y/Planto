//
//  AppFonts.swift
//  PlanTo
//
//  Text styles taken from the Sketch file "Plants App🌱" (SF Pro).
//

import SwiftUI

extension Font {

    // MARK: Titles
    static let screenTitle   = Font.system(size: 34, weight: .bold)       // My Plants 🌱
    static let stateTitle    = Font.system(size: 25, weight: .semibold)   // Start your plant journey! · All Done! 🎉
    static let emptyTitle    = Font.system(size: 20, weight: .semibold)   // No reminders set yet..

    // MARK: Plant row
    static let plantName     = Font.system(size: 28, weight: .regular)    // Monstera
    static let plantRoom     = Font.system(size: 15, weight: .regular)    // in Kitchen
    static let chipLight     = Font.system(size: 14, weight: .regular)    // Full sun
    static let chipWater     = Font.system(size: 14, weight: .medium)     // 20-50 ml

    // MARK: Progress
    static let progressText  = Font.system(size: 18, weight: .regular)    // Your plants are waiting for a sip 💦

    // MARK: Form
    static let formLabel     = Font.system(size: 18, weight: .regular)    // Room, Watering Days, values
    static let formPlaceholder = Font.system(size: 17, weight: .regular)  // Pothos

    // MARK: Body
    static let description   = Font.system(size: 16, weight: .regular)    // Now all your plants will be in one place…
}
