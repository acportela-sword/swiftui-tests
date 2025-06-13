import Foundation

extension Collection {
    func partitioned(where condition: (Element) -> Bool) -> (included: [Element], excluded: [Element]) {
        self.reduce(into: ([], [])) { result, element in
            if condition(element) {
                result.0.append(element)
            } else {
                result.1.append(element)
            }
        }
    }
}
