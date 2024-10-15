//
// Created by Joao Pedro Franco on 18/10/24
//
	
import CoreData

@objc(RatingEntity)
class RatingEntity: NSManagedObject {
	@NSManaged public var value: Double
	@NSManaged public var count: Int
	
	@discardableResult
	init(from rating: Rating, context: NSManagedObjectContext) {
		let entity = NSEntityDescription.entity(forEntityName: "RatingEntity", in: context)!
		super.init(entity: entity, insertInto: context)
		self.value = rating.value
		self.count = rating.count
	}
	
	override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
		super.init(entity: entity, insertInto: context)
	}
	
	static var entityDescription: NSEntityDescription = {
		let ratingEntity = NSEntityDescription()
		ratingEntity.name = "RatingEntity"
		ratingEntity.managedObjectClassName = NSStringFromClass(RatingEntity.self)
		
		let valueAttribute = NSAttributeDescription()
		valueAttribute.name = "value"
		valueAttribute.attributeType = .doubleAttributeType
		valueAttribute.isOptional = false
		
		let countAttribute = NSAttributeDescription()
		countAttribute.name = "count"
		countAttribute.attributeType = .integer64AttributeType
		countAttribute.isOptional = false
		
		ratingEntity.properties = [
			valueAttribute,
			countAttribute
		]
		
		return ratingEntity
	}()
}
