import Foundation
import SwiftData

@Model
final class Dish {
    var title: String
    var calories: Int

    init(title: String, calories: Int) {
        self.title = title
        self.calories = calories
    }
}
