import Foundation

extension Sequence {
    func firstOrDefault(_ fn: (Element) -> Bool) -> Element? {
        for item in self {
            if fn(item) {
                return item
            }
        }
        return nil
    }
}
