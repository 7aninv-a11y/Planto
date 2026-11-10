//
//  AppLayout.swift
//  PlanTo
//
//  Sizes and corner radii taken from the Sketch file "Plants App🌱".
//

import SwiftUI

enum AppLayout {

    // MARK: Corner radius
    static let fieldRadius: CGFloat        = 30   // Plant Name, Room/Light, Watering/Water groups
    static let deleteRowRadius: CGFloat    = 26   // Delete Reminder row
    static let sheetRadius: CGFloat        = 39   // sheet (top corners)
    static let progressRadius: CGFloat     = 4    // progress bar
    static let chipRadius: CGFloat         = 8    // Full sun / 20-50 ml chips

    // MARK: Heights
    static let nameFieldHeight: CGFloat    = 62
    static let deleteRowHeight: CGFloat    = 52
    static let progressHeight: CGFloat     = 8
    static let chipHeight: CGFloat         = 23
    static let primaryButtonHeight: CGFloat = 42  // Set Plant Reminder

    // MARK: Widths
    static let fieldWidth: CGFloat         = 388
    static let progressWidth: CGFloat      = 361
    static let primaryButtonWidth: CGFloat = 280

    // MARK: Controls
    static let circleButtonSize: CGFloat   = 44   // X, ✓, +
    static let checkCircleSize: CGFloat    = 23
    static let checkBorderWidth: CGFloat   = 1.2
}

enum AppIcons {
    static let room     = "location"
    static let light    = "sun.max"
    static let water    = "drop"
    static let add      = "plus"
    static let close    = "xmark"
    static let check    = "checkmark"
    static let delete   = "trash"
    static let picker   = "chevron.up.chevron.down"
}
