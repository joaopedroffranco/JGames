//
//  Created by Joao Pedro Franco on 16/07/24.
//

import SwiftUI
import JFoundation

/// A view that renders an image based on its type.
///
/// Displays a local image using the asset name, or fetches and displays a remote image from a URL.
/// If the image is remote, it is cached for future use.
public struct CachedImage: View {
	var image: ImageType
	
	public init(image: ImageType) {
		self.image = image
	}
	
	public var body: some View {
		switch image {
		case let .local(name):
			Image(name, bundle: .module)
				.resizable()
		case let .remote(url):
			if let cachedImage = ImageCache[url] {
				cachedImage
					.resizable()
			} else {
				AsyncImage(url: url) { phase in
					cacheAndRender(phase, forUrl: url)
						.resizable()
				}
			}
		}
	}
	
	private func cacheAndRender(_ phase: AsyncImagePhase, forUrl url: URL) -> Image {
		if case let .success(image) = phase {
			ImageCache[url] = image
			return image
		}
		
		return Image("placeholder", bundle: .module)
	}
}

public class ImageCache {
	static private var cache: [URL: Image] = [:]
	static subscript(url: URL) -> Image? {
		get { cache[url] }
		set { cache[url] = newValue }
	}
	
	public static func clean() { cache = [:] }
}
