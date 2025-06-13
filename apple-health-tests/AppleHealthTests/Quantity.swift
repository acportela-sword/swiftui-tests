import HealthKit

enum Quantity: CaseIterable, Identifiable {
	case restingHeartRate
	case heartRateVariabilitySDNN
	case oxygenSaturation
	case bodyTemperature
	case respiratoryRate
	case electrodermalActivity
	case uvExposure
	case heartRate

	// Read only
	case appleExerciseTime
	case walkingHeartRateAverage
	case appleSleepingWristTemperature // Not for now

    var id: String { self.identifier.rawValue }
    
    var sampleType: HKSampleType { HKQuantityType(self.identifier) }

	private var identifier: HKQuantityTypeIdentifier {
		switch self {
		case .restingHeartRate: .restingHeartRate
		case .heartRateVariabilitySDNN: .heartRateVariabilitySDNN
		case .oxygenSaturation: .oxygenSaturation
		case .bodyTemperature: .bodyTemperature
		case .respiratoryRate: .respiratoryRate
		case .electrodermalActivity: .electrodermalActivity
		case .uvExposure: .uvExposure
		case .heartRate: .heartRate
		case .appleExerciseTime: .appleExerciseTime
		case .walkingHeartRateAverage: .walkingHeartRateAverage
		case .appleSleepingWristTemperature: .appleSleepingWristTemperature
		}
	}

	var isReadOnly: Bool { HKQuantityTypeIdentifier.readOnlyTypes.contains(self.identifier) }

	var displayName: String {
		switch self {
		case .restingHeartRate: "Resting Heart Rate"
		case .heartRateVariabilitySDNN: "Heart Rate Variability SDNN"
		case .oxygenSaturation: "Oxygen Saturation"
		case .bodyTemperature: "Body Temperature"
		case .respiratoryRate: "Respiratory Rate"
		case .electrodermalActivity: "Electrodermal Activity"
		case .uvExposure: "UV Exposure"
		case .heartRate: "Heart Rate"
		case .appleExerciseTime: "Apple Exercise Time"
		case .walkingHeartRateAverage: "Walking Heart Rate Average"
		case .appleSleepingWristTemperature: "Apple Sleeping Wrist Temperature"
		}
	}
}
