import HealthKit

struct RequestSamplesBuilder {
    let writableQuantityTypes: [Quantity]
    let readOnlyQuantityTypes: [Quantity]
    
    let writableCategoryTypes: [Category]
    let readOnlyCategoryTypes: [Category]
    
    let writableOnlyScoredAsessmentTypes: [ScoredAssessment]
    let readOnlyScoredAsessmentTypes: [ScoredAssessment]
    
    /// Read Only
    let characteristics: [Characteristic] = Characteristic.allCases

    init() {
        let quantities = Quantity.allCases.partitioned(where: \.isReadOnly)
        let categories = Category.allCases.partitioned(where: \.isReadOnly)
        let assessments = ScoredAssessment.allCases.partitioned(where: \.isReadOnly)
        self.writableQuantityTypes = quantities.excluded
        self.readOnlyQuantityTypes = quantities.included
        self.writableCategoryTypes = categories.excluded
        self.readOnlyCategoryTypes = categories.included
        self.writableOnlyScoredAsessmentTypes = assessments.excluded
        self.readOnlyScoredAsessmentTypes = assessments.included
    }
    
    func readableSampleTypes() -> Set<HKObjectType> {
        let array = readOnlyQuantityTypes.map(\.sampleType)
        + readOnlyCategoryTypes.map(\.sampleType)
        + readOnlyScoredAsessmentTypes.map(\.sampleType)
        + characteristics.map(\.objectType)
        return Set(array)
    }
    
    func writableTypes() -> Set<HKSampleType> {
        let array = writableQuantityTypes.map(\.sampleType)
        + writableCategoryTypes.map(\.sampleType)
        + writableOnlyScoredAsessmentTypes.map(\.sampleType)
        return Set(array)
    }
}
