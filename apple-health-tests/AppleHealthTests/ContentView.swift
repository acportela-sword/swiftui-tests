import SwiftUI
import HealthKit
import HealthKitUI

struct ContentView: View {
	@State var healthStore = HKHealthStore()
	@State var authenticated = false
	@State var trigger = false

	let allQuantityTypes =  Quantities.allCases
	var writableQuantityTypes: Set<HKSampleType> {
		allQuantityTypes.reduce(into: Set()) { partialResult, element in
			if !element.isReadOnly { partialResult.insert(HKQuantityType(element.identifier)) }
		}
	}
	var readableQuantityTypes: Set<HKSampleType> { Set(allQuantityTypes.map { HKQuantityType($0.identifier) }) }

	@State var selectedQuantity: Quantities?

	var body: some View {
		VStack {
			List {
				Picker("Quantity type", selection: $selectedQuantity) {
					ForEach(allQuantityTypes, id: \.id) { element in
						Text(element.name).tag(element)
					}
				}
				.pickerStyle(.menu)
			}
		}
		.disabled(!authenticated)
		.onAppear { if HKHealthStore.isHealthDataAvailable() { trigger.toggle() } }
		.healthDataAccessRequest(
			store: healthStore,
			shareTypes: writableQuantityTypes,
			readTypes: readableQuantityTypes,
			trigger: trigger
		) { result in
			switch result {
			case .success(_): authenticated = true
			case .failure(let error): fatalError("Request error: \(error) ***")
			}
		}
	}
}

enum Categories: CaseIterable {
	case lowHeartRateEvent
	case highHeartRateEvent

	var identifier: HKCategoryTypeIdentifier {
		switch self {
		case .lowHeartRateEvent: .lowHeartRateEvent
		case .highHeartRateEvent: .highHeartRateEvent
		}
	}

	var isReadOnly: Bool {
		switch self {
		case .lowHeartRateEvent: false
		case .highHeartRateEvent: false
		}
	}

	var name: String {
		switch self {
		case .lowHeartRateEvent: "Low Heart Rate"
		case .highHeartRateEvent: "High Heart Rate"
		}
	}
}
enum Quantities: CaseIterable, Identifiable {
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

	var id: HKQuantityTypeIdentifier { self.identifier }

	var identifier: HKQuantityTypeIdentifier {
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

	var isReadOnly: Bool {
		switch self {
		case .restingHeartRate: false
		case .heartRateVariabilitySDNN: false
		case .oxygenSaturation: false
		case .bodyTemperature: false
		case .respiratoryRate: false
		case .electrodermalActivity: false
		case .uvExposure: false
		case .heartRate: false

		case .appleExerciseTime: true
		case .walkingHeartRateAverage: true
		case .appleSleepingWristTemperature: true
		}
	}

	var name: String {
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
