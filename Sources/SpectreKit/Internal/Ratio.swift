// Ported from Rich by Will McGugan, licensed under MIT.
// https://github.com/willmcgugan/rich/blob/527475837ebbfc427530b3ee0d4d0741d2d0fc6d/rich/_ratio.py

import Foundation

class Ratio {
    static func reduce(total: Int, ratios: [Int], maximums: [Int], values: [Int]) -> [Int] {
        let ratios =
            ratios.zip(maximums) { a, b in (ratio: a, max: b) }
            .map { $0.max > 0 ? $0.ratio : 0 }

        var totalRatio = ratios.sum()
        if totalRatio <= 0 {
            return values
        }

        var totalRemaining = total
        var result: [Int] = []

        for (ratio, maximum, value) in ratios.zip(maximums, values) {
            if ratio != 0 && totalRatio > 0 {
                let distributed = min(maximum, ratio * (totalRemaining / totalRatio))
                result.append(value - distributed)
                totalRemaining -= distributed
                totalRatio -= ratio
            } else {
                result.append(value)
            }
        }

        return result
    }

    static func distribute(total: Int, ratios: [Int], minimums: [Int]? = nil) -> [Int] {
        var ratios = ratios
        if let minimums = minimums {
            ratios = ratios.zip(minimums) { a, b in (ratio: a, min: b) }.map {
                $0.min > 0 ? $0.ratio : 0
            }
        }

        var totalRatio = ratios.sum()
        precondition(totalRatio > 0, "Sum of ratios must be greater than 0 (zero)")

        var totalRemaining = total
        var distributedTotal: [Int] = []

        let minimums = minimums ?? ratios.map({ _ in 0 })
        for (ratio, minimum) in ratios.zip(minimums) {
            let distributed =
                (totalRatio > 0)
                ? max(minimum, Int(ceil(Double(ratio * totalRemaining / totalRatio))))
                : totalRemaining

            distributedTotal.append(distributed)
            totalRatio -= ratio
            totalRemaining -= distributed
        }

        return distributedTotal
    }
}
