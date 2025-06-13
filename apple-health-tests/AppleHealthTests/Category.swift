import HealthKit

enum Category: CaseIterable, Identifiable {
	case lowHeartRateEvent
	case highHeartRateEvent
    
    var id: String { self.identifier.rawValue }

	private var identifier: HKCategoryTypeIdentifier {
		switch self {
		case .lowHeartRateEvent: .lowHeartRateEvent
		case .highHeartRateEvent: .highHeartRateEvent
		}
	}
    
    var sampleType: HKSampleType { HKCategoryType(self.identifier) }

    var isReadOnly: Bool { HKCategoryTypeIdentifier.readOnlyTypes.contains(self.identifier) }

	var displayName: String {
		switch self {
		case .lowHeartRateEvent: "Low Heart Rate"
		case .highHeartRateEvent: "High Heart Rate"
		}
	}
}
