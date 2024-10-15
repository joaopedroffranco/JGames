//
//  Created by João Pedro Fabiano Franco
//

import SwiftUI

/// Defines the app's Design System.
///
/// Instead of using hardcoded values, these resources are referenced to allow easy updates when the brand changes.
///
/// The available resources include `Colors`, `Fonts`, `Radius`, and `Spacings`.
public enum DesignSystem {
  public enum Colors {
		public static let white = Color(red: 248/255, green: 249/255, blue: 249/255)
		public static let background = white
		public static let dark = Color(red: 23/255, green: 32/255, blue: 42/255)
		public static let yellow = Color(red: 247/255, green: 220/255, blue: 111/255)
  }

  public enum Fonts {
		public static let title = Font.system(size: 32)
		public static let `default` = Font.system(size: 16)
		public static let small = Font.system(size: 12)
		public static let huge = Font.system(size: 96)
		public static let section = Font.system(size: 20)
		
  }

  public enum Radius {
		public static let `default`: CGFloat = 8.0
  }

  public enum Spacings {
    public static let xs = 8.0
    public static let xxs = 6.0
    public static let xxxs = 4.0
    public static let xxxxs = 2.0
  }
}
