import SwiftUI
import HealthKit
import HealthKitUI

struct ReadDataView: View {
    let healthStore: HKHealthStore

    let quantityTypes = Quantity.allCases

	@State var selectedQuantity: Quantity?

	var body: some View {
		VStack {
			List {
                Section {
                    ForEach(quantityTypes, id: \.id) { quantity in
                        Row(name: quantity.displayName, statisticType: "Average", value: 5)
                    }
                } header: {
                    Text("Quantity Types")
                } footer: {
                    Text("Total: \(quantityTypes.count)")
                }
                .headerProminence(.increased)

//				Picker("Quantity type", selection: $selectedQuantity) {
//                    ForEach(allTypes.writableQuantityTypes, id: \.id) { element in
//						Text(element.displayName).tag(element)
//					}
//				}
//				.pickerStyle(.menu)
			}
		}
	}
}

struct Row: View {
    let name: String
    let statisticType: String
    let value: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(name)
                    .font(.subheadline)
                Spacer()
                Text(statisticType)
                    .font(.subheadline)
                    .frame(alignment: .trailing)
            }
            
            HStack {
                Spacer()
                Text("\(value)")
                    .font(.subheadline)
                    .frame(alignment: .trailing)
            }
        }
    }
}
protocol AppleHealthMetric: Identifiable {
    var displayName: String { get }
    var isReadOnly: Bool { get }
    var id: String { get }
}
