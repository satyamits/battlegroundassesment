// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Assets {
    internal static let accentColor = ColorAsset(name: "AccentColor")
  }
  internal enum Colors {
    internal static let aeroBorderPrimary = ColorAsset(name: "AeroBorderPrimary")
    internal static let aeroBorderSecondary = ColorAsset(name: "AeroBorderSecondary")
    internal static let deepSea = ColorAsset(name: "DeepSea")
    internal static let gradeintButtonColorPrimary = ColorAsset(name: "GradeintButtonColorPrimary")
    internal static let gradeintButtonColorSecondary = ColorAsset(name: "GradeintButtonColorSecondary")
    internal static let chartPrimary = ColorAsset(name: "ChartPrimary")
    internal static let chartSecondary = ColorAsset(name: "ChartSecondary")
    internal static let deleteColor = ColorAsset(name: "DeleteColor")
    internal static let keyboardGray = ColorAsset(name: "KeyboardGray")
    internal static let lightGrayDisbaled = ColorAsset(name: "LightGrayDisbaled")
    internal static let blackPrimary = ColorAsset(name: "BlackPrimary")
    internal static let blurBackground = ColorAsset(name: "BlurBackground")
    internal static let brightYellow = ColorAsset(name: "BrightYellow")
    internal static let charcoalGray = ColorAsset(name: "CharcoalGray")
    internal static let chocolateBrown = ColorAsset(name: "ChocolateBrown")
    internal static let darkGrey = ColorAsset(name: "DarkGrey")
    internal static let darkPrimary = ColorAsset(name: "DarkPrimary")
    internal static let deepBlue = ColorAsset(name: "DeepBlue")
    internal static let deepBlueOff = ColorAsset(name: "DeepBlueOff")
    internal static let dividerGray = ColorAsset(name: "DividerGray")
    internal static let hyxBlue = ColorAsset(name: "HyxBlue")
    internal static let hyxPink = ColorAsset(name: "HyxPink")
    internal static let midnightTransparent = ColorAsset(name: "MidnightTransparent")
    internal static let mutedTeal = ColorAsset(name: "MutedTeal")
    internal static let overlayLight = ColorAsset(name: "OverlayLight")
    internal static let progressGreen = ColorAsset(name: "ProgressGreen")
    internal static let seaNymph = ColorAsset(name: "SeaNymph")
    internal static let successGreen = ColorAsset(name: "SuccessGreen")
    internal static let surfaceBrown = ColorAsset(name: "SurfaceBrown")
    internal static let tabBarColor = ColorAsset(name: "TabBarColor")
    internal static let tealGreen = ColorAsset(name: "TealGreen")
    internal static let tertiaryGray = ColorAsset(name: "TertiaryGray")
    internal static let yellowLime = ColorAsset(name: "YellowLime")
    internal static let paper = ColorAsset(name: "paper")
    internal static let tabForegroundColor = ColorAsset(name: "tabForegroundColor")
    internal static let themeWhite = ColorAsset(name: "themeWhite")
    internal static let darkestGreen = ColorAsset(name: "DarkestGreen")
    internal static let deepTeal = ColorAsset(name: "DeepTeal")
    internal static let dirtyGreen = ColorAsset(name: "DirtyGreen")
    internal static let jewel = ColorAsset(name: "Jewel")
    internal static let limeColor = ColorAsset(name: "LimeColor")
    internal static let liveSessionGrad2 = ColorAsset(name: "LiveSessionGrad2")
    internal static let pausedSessionGrad1 = ColorAsset(name: "PausedSessionGrad1")
    internal static let pausedSessionGrad3 = ColorAsset(name: "PausedSessionGrad3")
    internal static let sessionButtonGradientPrimary = ColorAsset(name: "SessionButtonGradientPrimary")
    internal static let sessionButtonGradientSecondary = ColorAsset(name: "SessionButtonGradientSecondary")
    internal static let summaryGradientPrimary = ColorAsset(name: "SummaryGradientPrimary")
    internal static let summaryGradientSecondary = ColorAsset(name: "SummaryGradientSecondary")
    internal static let summaryGradientTertiary = ColorAsset(name: "SummaryGradientTertiary")
    internal static let pausedSessionGrad2 = ColorAsset(name: "pausedSessionGrad2")
    internal static let shuttleGray = ColorAsset(name: "ShuttleGray")
    internal static let limeGreen = ColorAsset(name: "LimeGreen")
    internal static let textOrange = ColorAsset(name: "TEXT_Orange")
    internal static let textSecondaryGray = ColorAsset(name: "TEXT_SECONDARY_GRAY")
    internal static let primary = ColorAsset(name: "PRIMARY")
    internal static let secondary = ColorAsset(name: "SECONDARY")
    internal static let tertiary = ColorAsset(name: "TERTIARY")
    internal static let grayDivider = ColorAsset(name: "grayDivider")
    internal static let paleBlueGray = ColorAsset(name: "paleBlueGray")
    internal static let whiteTransparent = ColorAsset(name: "whiteTransparent")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
