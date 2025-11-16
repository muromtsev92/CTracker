import SwiftUI
import SwiftData

struct EditDishView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @Bindable var dish: Dish

    var body: some View {
        Form {
            TextField("Название", text: $dish.title)
            TextField("Калории", value: $dish.calories, formatter: NumberFormatter())
                .keyboardType(.numberPad)
        }
        .navigationTitle("Редактировать")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Готово") { dismiss() }
            }
        }
    }
}

#Preview {
    EditDishView(dish: Dish(title: "Яичница", calories: 250))
        .modelContainer(for: [Dish.self, EatenMeal.self])
}
