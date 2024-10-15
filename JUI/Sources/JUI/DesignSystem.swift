//
//  Created by João Pedro Fabiano Franco
//

import SwiftUI

public enum DesignSystem {
  public enum Colors {
		public static let dark = Color(red: 25/255, green: 25/255, blue: 25/255)
		public static let white = Color(red: 248/255, green: 249/255, blue: 249/255)
		public static let background = white
		public static let primary = Color(red: 52/255, green: 55/255, blue: 59/255)
		public static let secondary = Color(red: 145/255, green: 71/255, blue: 255/255)
		public static let green = Color(red: 99/255, green: 152/255, blue: 103/255)
		public static let red = Color(red: 255/255, green: 101/255, blue: 104/255)
  }

  public enum Fonts {
		public static let `default` = Font.system(size: 16)
		public static let big = Font.system(size: 20)
		public static let title = Font.system(size: 32)
		public static let small = Font.system(size: 12)
		public static let section = Font.system(size: 20).bold()
		
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
	
	public enum Icons: String {
		case placeholder
		case star
	}
}
