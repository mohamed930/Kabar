// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum myStrings {
  /// Attension
  internal static let attension = myStrings.tr("Localizable", "Attension", fallback: "Attension")
  /// Article Details
  internal static let details = myStrings.tr("Localizable", "details", fallback: "Article Details")
  /// Localizable.strings
  ///   Kaber
  /// 
  ///   Created by Mohamed Ali on 15/08/2023.
  internal static let lang = myStrings.tr("Localizable", "Lang", fallback: "en")
  /// you must restart app to change language?
  internal static let langMess = myStrings.tr("Localizable", "langMess", fallback: "you must restart app to change language?")
  /// news
  internal static let news = myStrings.tr("Localizable", "news", fallback: "news")
  /// Please wait
  internal static let pleaseWait = myStrings.tr("Localizable", "pleaseWait", fallback: "Please wait")
  /// read More
  internal static let readMore = myStrings.tr("Localizable", "readMore", fallback: "read More")
  /// restart
  internal static let restart = myStrings.tr("Localizable", "restart", fallback: "restart")
  /// Search
  internal static let search = myStrings.tr("Localizable", "search", fallback: "Search")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension myStrings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

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
