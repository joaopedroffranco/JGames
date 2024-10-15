//
// Created by Joao Pedro Franco on 18/10/24
//
	
import CoreData

@objc(GenreEntity)
class GenreEntity: NSManagedObject {
	@NSManaged public var name: String
	
	@discardableResult
	init(from genre: Genre, context: NSManagedObjectContext) {
		let entity = NSEntityDescription.entity(forEntityName: "GenreEntity", in: context)!
		super.init(entity: entity, insertInto: context)
		self.name = genre.name
	}
	
	override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
		super.init(entity: entity, insertInto: context)
	}
	
	static var entityDescription: NSEntityDescription = {
		let genreEntity = NSEntityDescription()
		genreEntity.name = "GenreEntity"
		genreEntity.managedObjectClassName = NSStringFromClass(GenreEntity.self)
		
		let nameAttribute = NSAttributeDescription()
		nameAttribute.name = "name"
		nameAttribute.attributeType = .stringAttributeType
		nameAttribute.isOptional = false
		
		genreEntity.properties = [
			nameAttribute
		]
		
		return genreEntity
	}()
}
