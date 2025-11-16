import SwiftUI
import SwiftData

@main
struct FoodTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            DayView()
        }
        .modelContainer(for: [Dish.self, EatenMeal.self])
    }
}
