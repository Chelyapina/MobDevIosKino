import SwiftUI

enum AppFont {
    static func regular(_ size: CGFloat) -> Font {
        .custom("Montserrat-Regular", size: size)
    }

    static func medium(_ size: CGFloat) -> Font {
        .custom("Montserrat-Medium", size: size)
    }

    static func semibold(_ size: CGFloat) -> Font {
        .custom("Montserrat-SemiBold", size: size)
    }

    static func bold(_ size: CGFloat) -> Font {
        .custom("Montserrat-Bold", size: size)
    }
}
