//
// Created by Joao Pedro Franco on 18/10/24
//
	
import CoreData

@objc(ScreenshotEntity)
class ScreenshotEntity: NSManagedObject {
	@NSManaged public var id: String
	
	@discardableResult
	init(from screenshot: Screenshot, context: NSManagedObjectContext) {
		let entity = NSEntityDescription.entity(forEntityName: "ScreenshotEntity", in: context)!
		super.init(entity: entity, insertInto: context)
		self.id = screenshot.id
	}
	
	override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
		super.init(entity: entity, insertInto: context)
	}
	
	static var entityDescription: NSEntityDescription = {
		let screenshotEntity = NSEntityDescription()
		screenshotEntity.name = "ScreenshotEntity"
		screenshotEntity.managedObjectClassName = NSStringFromClass(ScreenshotEntity.self)
		
		let idAttribute = NSAttributeDescription()
		idAttribute.name = "id"
		idAttribute.attributeType = .stringAttributeType
		idAttribute.isOptional = false
		
		screenshotEntity.properties = [
			idAttribute
		]
		
		return screenshotEntity
	}()
}
