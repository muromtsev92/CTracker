import SwiftUI
import SwiftData

struct DishPickerView: View {

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @Query(sort: \Dish.title, order: .forward)
    private var dishes: [Dish]

    let onDishSelected: (Dish) -> Void

    var body: some View {
        NavigationStack {
            List {
                ForEach(dishes) { dish in
                    Button {
                        onDishSelected(dish)
                        dismiss()
                    } label: {
                        HStack {
                            Text(dish.title)
                            Spacer()
                            Text("\(dish.calories) ккал")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Выберите блюдо")
        }
    }
}

#Preview {
    DishPickerView { _ in }
        .modelContainer(for: [Dish.self, EatenMeal.self])
}
