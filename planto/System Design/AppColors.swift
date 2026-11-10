//
//  AppColors.swift
//  PlanTo
//
//  Colors taken from the Sketch file "Plants App🌱" (dark appearance).
//

import SwiftUI

extension Color {

    // MARK: Backgrounds
    static let appBackground     = Color(hex: "000000")   // all screens
    static let sheetBackground   = Color(hex: "1C1C1E")   // Set Reminder sheet
    static let fieldBackground   = Color(hex: "2C2C2E")   // form fields, Delete Reminder row

    // MARK: Dividers
    static let fieldDivider      = Color(hex: "414144")   // inside form groups
    static let headerDivider     = Color(hex: "39393B")   // under "My Plants"
    static let rowDivider        = Color(hex: "222224")   // between plant rows

    // MARK: Brand
    static let primaryGreen      = Color(hex: "338069")   // Set Plant Reminder, + , ✓ , progress fill
    static let checkGreen        = Color(hex: "28E0A8")   // checked circle, text cursor
    static let destructiveRed    = Color(hex: "FF3B30")   // Delete Reminder, swipe delete

    // MARK: Progress
    static let progressTrack     = Color(hex: "262626")   // progress bar background

    // MARK: Row
    static let uncheckedBorder   = Color(hex: "979797")   // unchecked circle border (1.2 pt)
    static let chipBackground    = Color(hex: "18181D")   // Full sun / 20-50 ml chips
    static let chipText          = Color(hex: "CCC785")   // Full sun chip (yellow)
    static let chipWaterText     = Color(hex: "CAF3FB")   // 20-50 ml chip (light cyan)

    // MARK: Text
    static let textPrimary       = Color(hex: "FFFFFF")                // titles, plant names, labels
    static let textRoom          = Color(hex: "FFFFFF").opacity(0.5)   // "in Kitchen"
    static let textValue         = Color(hex: "8E8E93")                // picker values
    static let textPlaceholder   = Color(hex: "666666")                // "Pothos" placeholder
    static let textSecondary     = Color(hex: "9F9F91")                // descriptions
    static let textEmpty         = Color(hex: "756F6F")                // "No reminders set yet.."
}

// MARK: - Hex helper
extension Color {
    /// Creates a color from a hex string like "338069".
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)

        let red   = Double((value >> 16) & 0xFF) / 255
        let green = Double((value >> 8)  & 0xFF) / 255
        let blue  = Double(value & 0xFF) / 255

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)
    }
}
