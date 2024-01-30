import Foundation
import SwiftUI
import UIKit

public extension UIDevice {
    var isPad: Bool {
        return userInterfaceIdiom == .pad
    }
}

// Device orientation Observer
public struct DeviceOrientationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    public func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// A View wrapper to make the modifier easier to use
public extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        modifier(DeviceOrientationViewModifier(action: action))
    }
}
