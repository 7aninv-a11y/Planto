import SwiftUI

struct CircleButton: View {

    enum Style {
        case green      // ✅ و ➕
        case dark       // ❌
    }

    let icon: String
    var style: Style = .green
    let action: () -> Void

    // الألوان من Sketch
    private var fillColor: Color {
        style == .green ? .primaryGreen : Color(hex: "1A1A1A")
    }
    private var glassColor: Color {
        style == .green ? Color(hex: "9BE8D1")   // أخضر فاتح
                        : Color(hex: "BDBDBD")   // فضي
    }
    private var iconColor: Color {
        style == .green ? .white : Color(hex: "EDEDED")
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(iconColor)
                .frame(width: AppLayout.circleButtonSize,
                       height: AppLayout.circleButtonSize)   // 44 × 44
                .background(
                    Circle()
                        .fill(fillColor)
                        .overlay(
                            Circle().strokeBorder(glassEdge, lineWidth: 1.25)   // حافة الزجاج
                        )
                )
        }
    }
    

    // الزجاج: قوي فوق وتحت، وخفيف يمين ويسار
    private var glassEdge: LinearGradient {
        LinearGradient(stops: [
            .init(color: glassColor,                location: 0.0),   // فوق: قوي
            .init(color: glassColor.opacity(0.25),  location: 0.35),  // يمين ويسار: خفيف
            .init(color: glassColor.opacity(0.25),  location: 0.65),
            .init(color: glassColor,                location: 1.0)    // تحت: قوي
        ], startPoint: .top, endPoint: .bottom)
    }
}

#Preview {
    HStack(spacing: 20) {
        CircleButton(icon: AppIcons.close, style: .dark) { }
        CircleButton(icon: AppIcons.check) { }
        CircleButton(icon: AppIcons.add) { }
    }
    .padding()
    .background(Color.sheetBackground)
}
