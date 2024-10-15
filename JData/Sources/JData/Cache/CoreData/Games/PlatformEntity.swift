//
// Created by Joao Pedro Franco on 18/10/24
//
	
import CoreData

@objc(PlatformEntity)
class PlatformEntity: NSManagedObject {
	@NSManaged public var name: String
	
	@discardableResult
	init(from platform: Platform, context: NSManagedObjectContext) {
		let entity = NSEntityDescription.entity(forEntityName: "PlatformEntity", in: context)!
		super.init(entity: entity, insertInto: context)
		self.name = platform.name
	}
	
	override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
		super.init(entity: entity, insertInto: context)
	}
	
	static var entityDescription: NSEntityDescription = {
		let platformEntity = NSEntityDescription()
		platformEntity.name = "PlatformEntity"
		platformEntity.managedObjectClassName = NSStringFromClass(PlatformEntity.self)
		
		let nameAttribute = NSAttributeDescription()
		nameAttribute.name = "name"
		nameAttribute.attributeType = .stringAttributeType
		nameAttribute.isOptional = false
		
		platformEntity.properties = [
			nameAttribute
		]
		
		return platformEntity
	}()
}
