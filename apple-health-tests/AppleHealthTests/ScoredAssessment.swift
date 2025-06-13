import HealthKit

enum ScoredAssessment: CaseIterable, Identifiable {
    case gad7
    case phq9
    
    var id: String { self.identifier.rawValue }
    
    private var identifier: HKScoredAssessmentTypeIdentifier {
        switch self {
        case .gad7: .GAD7
        case .phq9: .PHQ9
        }
    }
    
    var displayName: String {
        switch self {
        case .gad7: "Generalised Anxiety Disorder Questionnaire (GAD-7)"
        case .phq9: "Phobias and Related Disorders Questionnaire (PHQ-9)"
        }
    }
    
    var isReadOnly: Bool { HKScoredAssessmentTypeIdentifier.readOnlyTypes.contains(self.identifier) }
    
    var sampleType: HKSampleType { HKScoredAssessmentType(self.identifier) }
}
