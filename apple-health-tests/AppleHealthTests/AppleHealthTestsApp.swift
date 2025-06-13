import SwiftUI
import HealthKit

@main
struct AppleHealthTestsApp: App {
    @State var healthStore = HKHealthStore()

    var body: some Scene {
        WindowGroup {
            TabBarView(healthStore: healthStore)
        }
    }
}

struct TabBarView: View {
    @State var authenticated = false
    @State var trigger = false
    
    let allTypes = RequestSamplesBuilder()
    let healthStore: HKHealthStore
    
    var body: some View {
        TabView {
            Tab("Read", systemImage: "heart.text.square") {
                ReadDataView(healthStore: healthStore)
            }
            Tab("Write", systemImage: "arrow.down.heart") {
                EmptyView()
            }
        }
        .disabled(!authenticated)
        .onAppear { if HKHealthStore.isHealthDataAvailable() { trigger.toggle() } }
        .healthDataAccessRequest(
            store: healthStore,
            shareTypes: allTypes.writableTypes(),
            readTypes: allTypes.readableSampleTypes(),
            trigger: trigger
        ) { result in
            switch result {
            case .success(_): authenticated = true
            case .failure(let error): fatalError("Request error: \(error) ***")
            }
        }
    }
}
