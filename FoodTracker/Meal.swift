import Foundation
import SwiftData

@Model
final class Meal {
    var title: String
    var calories: Int
    var date: Date

    init(title: String, calories: Int, date: Date = .now) {
        self.title = title
        self.calories = calories
        self.date = date
    }
}
