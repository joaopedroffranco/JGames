//
//  Created by João Pedro Fabiano Franco
//

import Foundation

/// Represents an image type, either from a `local` asset or a `remote` URL.
public enum ImageType {
	case local(String)
  case remote(URL?)
}
