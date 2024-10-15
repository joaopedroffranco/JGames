//
// Created by Joao Pedro Franco on 17/10/24
//

import SwiftUI

public struct Carousel<Data: Hashable, Cell: View>: View {
	private var data: [Data]
	private var cellView: (Int, Data) -> Cell
	private let spacing: CGFloat
	private let cellRatio: CGFloat
	
	public init(
		data: [Data],
		spacing: CGFloat = .zero,
		cellRatio: CGFloat = 0.5,
		@ViewBuilder cell: @escaping (Int, Data) -> Cell
	) {
		self.data = data
		self.cellView = cell
		self.spacing = spacing
		self.cellRatio = max(0, min(1, cellRatio))
	}
	
	public var body: some View {
		GeometryReader { geometry in
			ScrollView(.horizontal, showsIndicators: false) {
				LazyHStack(spacing: spacing) {
					ForEach(Array(data.enumerated()), id: \.offset) { index, object in
						cellView(index, object)
							.frame(width: geometry.size.width * cellRatio)
							.cornerRadius(DesignSystem.Radius.default)
					}
				}
			}
		}
	}
}

struct Carousel_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			Carousel(
				data: [1 ,2, 3],
				spacing: 10,
				cellRatio: 0.75) { index, element in
					Rectangle().fill(.blue)
			 }
				.frame(height: 200)
			
			Carousel(
				data: [1 ,2, 3, 4, 5, 6],
				spacing: 10,
				cellRatio: 0.25) { index, element in
					Rectangle().fill(.red)
			 }
				.frame(height: 50)
			
			Carousel(
				data: [1 ,2, 3, 4, 5, 6],
				spacing: 10,
				cellRatio: 10) { index, element in
					Rectangle().fill(.yellow)
			 }
				.frame(height: 50)
		}
		.padding()
		.previewLayout(.sizeThatFits)
	}
}


