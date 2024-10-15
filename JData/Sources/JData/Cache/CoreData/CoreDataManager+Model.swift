//
// Created by Joao Pedro Franco on 18/10/24
//

import CoreData

extension CoreDataManager {
	static func createModel() -> NSManagedObjectModel {
		let model = NSManagedObjectModel()

		model.entities = [
			RatingEntity.entityDescription,
			PlatformEntity.entityDescription,
			GenreEntity.entityDescription,
			ScreenshotEntity.entityDescription,
			GameEntity.entityDescription
		]
		
		return model
	}
}
