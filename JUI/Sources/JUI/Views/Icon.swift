//
//  Created by Joao Pedro Franco on 16/07/24.
//

import SwiftUI
import JFoundation

public struct Icon: View {
	var name: String
	
	public init(name: String) {
		self.name = name
	}
	
	public var body: some View {
		Image(name, bundle: .module)
			.resizable()
	}
}
