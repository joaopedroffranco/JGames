//
// Created by Joao Pedro Franco on 17/10/24
//

import CoreData

@objc(GameEntity)
class GameEntity: NSManagedObject {
	@NSManaged public var id: Int64
	@NSManaged public var name: String
	@NSManaged public var releasedAt: Double
	@NSManaged public var summary: String?
	@NSManaged public var rating: RatingEntity?
	@NSManaged public var platforms: Set<PlatformEntity>?
	@NSManaged public var genres: Set<GenreEntity>?
	@NSManaged public var screenshots: Set<ScreenshotEntity>?
	
	@discardableResult
	init(from game: Game, context: NSManagedObjectContext) {
		let entity = NSEntityDescription.entity(forEntityName: "GameEntity", in: context)!
		super.init(entity: entity, insertInto: context)
		self.id = Int64(game.id)
		self.name = game.name
		self.releasedAt = game.releasedAt ?? .zero
		self.summary = game.summary
		
		if let platforms = game.platforms?.compactMap({ PlatformEntity(from: $0, context: context) }) {
			self.platforms = Set(platforms)
		} else {
			self.platforms = nil
		}

		if let genres = game.genres?.compactMap({ GenreEntity(from: $0, context: context) }) {
			self.genres = Set(genres)
		} else {
			self.genres = nil
		}
		
		if let rating = game.rating {
			self.rating = RatingEntity(from: rating, context: context)
		} else {
			self.rating = nil
		}
		
		if let screenshots = game.screenshots?.compactMap({ ScreenshotEntity(from: $0, context: context) }) {
			self.screenshots = Set(screenshots)
		} else {
			self.screenshots = nil
		}
	}
	
	override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
		super.init(entity: entity, insertInto: context)
	}
	
	static var entityDescription: NSEntityDescription = {
		let gameEntity = NSEntityDescription()
		gameEntity.name = "GameEntity"
		gameEntity.managedObjectClassName = NSStringFromClass(GameEntity.self)
		
		let idAttribute = NSAttributeDescription()
		idAttribute.name = "id"
		idAttribute.attributeType = .integer64AttributeType
		idAttribute.isOptional = false
		
		let nameAttribute = NSAttributeDescription()
		nameAttribute.name = "name"
		nameAttribute.attributeType = .stringAttributeType
		nameAttribute.isOptional = false
		
		let releaseAttribute = NSAttributeDescription()
		releaseAttribute.name = "releasedAt"
		releaseAttribute.attributeType = .doubleAttributeType
		releaseAttribute.isOptional = true
		
		let summaryAttribute = NSAttributeDescription()
		summaryAttribute.name = "summary"
		summaryAttribute.attributeType = .stringAttributeType
		summaryAttribute.isOptional = true
		
		let ratingAttribute = NSRelationshipDescription()
		ratingAttribute.name = "rating"
		ratingAttribute.destinationEntity = RatingEntity.entityDescription
		ratingAttribute.minCount = 1
		ratingAttribute.maxCount = 1
		ratingAttribute.deleteRule = .cascadeDeleteRule
		
		let platformsAttribute = NSRelationshipDescription()
		platformsAttribute.name = "platforms"
		platformsAttribute.destinationEntity = PlatformEntity.entityDescription
		platformsAttribute.minCount = 0
		platformsAttribute.maxCount = 0
		platformsAttribute.deleteRule = .cascadeDeleteRule
		
		let genresAttribute = NSRelationshipDescription()
		genresAttribute.name = "genres"
		genresAttribute.destinationEntity = GenreEntity.entityDescription
		genresAttribute.minCount = 0
		genresAttribute.maxCount = 0
		genresAttribute.deleteRule = .cascadeDeleteRule
		
		let screenshotsAttribute = NSRelationshipDescription()
		screenshotsAttribute.name = "screenshots"
		screenshotsAttribute.destinationEntity = ScreenshotEntity.entityDescription
		screenshotsAttribute.minCount = 0
		screenshotsAttribute.maxCount = 0
		screenshotsAttribute.deleteRule = .cascadeDeleteRule
		
		gameEntity.properties = [
			idAttribute,
			nameAttribute,
			releaseAttribute,
			summaryAttribute,
			ratingAttribute,
			platformsAttribute,
			genresAttribute,
			screenshotsAttribute
		]
		
		return gameEntity
	}()
}
