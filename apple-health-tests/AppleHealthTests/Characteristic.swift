import HealthKit

/// Readable information only
enum Characteristic: CaseIterable, Identifiable {
    case biologicalSex
    case bloodType
    case fitzpatrickSkinType
    case birthdate
    case wheelchairUse
    case activityMoveMode
    
    var id: String { self.identifier.rawValue }
    
    var objectType: HKObjectType { HKCharacteristicType(self.identifier) }

    var isReadOnly: Bool { true }
        
    private var identifier: HKCharacteristicTypeIdentifier {
        switch self {
        case .biologicalSex: .biologicalSex
        case .bloodType: .bloodType
        case .fitzpatrickSkinType: .fitzpatrickSkinType
        case .birthdate: .dateOfBirth
        case .wheelchairUse: .wheelchairUse
        case .activityMoveMode: .activityMoveMode
        }
    }
    
    var displayName: String {
        switch self {
        case .biologicalSex: "Biological Sex"
        case .bloodType: "Blood Type"
        case .fitzpatrickSkinType: "Fitzpatrick Skin Type"
        case .birthdate: "Date of Birth"
        case .wheelchairUse: "Wheelchair Use"
        case .activityMoveMode: "Activity Move Mode"
        }
    }
}
