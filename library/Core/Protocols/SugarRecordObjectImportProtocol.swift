protocol SugarRecordObjectImportProtocol: SugarRecordObjectProtocol
{
	class func mapAttributes(#remoteObject: JSON, localObject: SugarRecordObjectProtocol, mappingModel: MappingModel)
	class func mapRelationships(#remoteObject: JSON, localObject: SugarRecordObjectProtocol, mappingModel: MappingModel, cache: [RemoteKey: [String: Anyobject]])
	class func import(#object: JSON, inContext context: SugarRecordContext, scheme: MappinScheme?) -> SugarRecordObjectProtocol
	class func import(#array: JSON, inContext context: SugarRecordContext, scheme: MappingScheme?) -> [SugarRecordObjectProtocol]

}

protocol SugarRecordObjectMappingProtocol
{
	//class func mappingModel(scheme: MappingScheme?) -> MappingModel
	var mappingModel: MappingModel
}

enum MappingScheme
{
	case scheme(name: String)
}

enum MappingAttributeType
{
	case simpleAttribute, identiferAttribute,
	case relationshipAttribute(let prefetch: Bool, dest: AnyClass) // Check if dest conforms SugarRecordObjectProtocol
}

struct MappingAttribute
{
	let localKey: String?
	let remoteKey: String?
	let type: MappingAttributeType?
	// let class: ??????
}

class MappingModel
{
	var attributes: [MappingAttribute]

	func prefetchRelationships() -> ([MappingAttribute])
	func simpleRelationships() -> ([MappingAttribute])
	func attributes() -> ([MappingAttribute])
	func relationships() -> ([MappingAttribute])

	class func builder() {
		return MappingModel()
	}

	func add(attribute: String) -> MapingModel
	 {
		attributes.append
	}
}

// Project.by(NSPredicate(...)).find() as [Project]


// return MappingModel.builder().
// add("name").
// add("project", )


// Cache : [RemoteKey: [String: Anyobject]]


// Caching steps
// 1) Import array
// 2) Create cache
// 	2.1) Find prefetch attributes
//	2.2) Find common objects in the JSON file
//	2.3) Fetch common objects
// 3) Map attributes
// 4) Map relationships (with cache)

// Pass mappingModel in method
