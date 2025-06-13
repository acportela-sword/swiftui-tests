import HealthKit

/// HKCharacteristicType cannot be saved, only read, and not using queries
/// As of today: biological sex, blood type, birthdate, Fitzpatrick skin type, and wheelchair use

extension HKQuantityTypeIdentifier {
    /// Apple doesn't provide an API where we can query if a particular type is read only
    static var readOnlyTypes: Set<HKQuantityTypeIdentifier> {
        [
            .walkingHeartRateAverage,
            .appleStandTime,
            .appleExerciseTime,
            .appleMoveTime,
            .appleSleepingBreathingDisturbances,
            .appleSleepingWristTemperature,
            .appleWalkingSteadiness,
        ]
    }
}

extension HKCategoryTypeIdentifier {
    /// Apple doesn't provide an API where we can query if a particular type is read only
    /// Add tested read-only types here
    static var readOnlyTypes: Set<HKCategoryTypeIdentifier> {
        [.lowHeartRateEvent, .highHeartRateEvent]
    }
}

extension HKScoredAssessmentTypeIdentifier {
    /// Apple doesn't provide an API where we can query if a particular type is read only
    /// Add tested read-only types here
    static var readOnlyTypes: Set<HKScoredAssessmentTypeIdentifier> { [] }
}
