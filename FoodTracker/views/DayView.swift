import SwiftUI
import SwiftData

struct DayView: View {

    @Environment(\.modelContext) private var context

    // выбранная дата
    @State private var selectedDate = Calendar.current.startOfDay(for: Date())

    // меню
    @State private var showMenu = false

    // экран выбора блюда
    @State private var showDishPicker = false

    // динамический список съеденных блюд
    @State private var eatenMeals: [EatenMeal] = []

    var body: some View {
        NavigationStack {
            VStack {

                // MARK: - Date Header
                HStack {
                    Button(action: { changeDay(-1) }) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                    }

                    Spacer()

                    Text(dateString(selectedDate))
                        .font(.title3)
                        .fontWeight(.semibold)

                    Spacer()

                    Button(action: { changeDay(1) }) {
                        Image(systemName: "chevron.right")
                            .font(.title3)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                .gesture(
                    DragGesture().onEnded { value in
                        if value.translation.width > 80 { changeDay(-1) }
                        else if value.translation.width < -80 { changeDay(1) }
                    }
                )

                // MARK: - Total
                HStack {
                    Text("Итого:")
                    Spacer()
                    Text("\(totalCalories) ккал")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                .padding(.horizontal)
                .padding(.vertical, 4)

                // MARK: - List of eaten meals
                List {
                    ForEach(eatenMeals) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.dish.title)
                                Text(timeString(item.time))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text("\(item.dish.calories) ккал")
                                .fontWeight(.semibold)
                        }
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.plain)

                // MARK: - Add button
                Button(action: {
                    showDishPicker = true
                }) {
                    Text("Добавить")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
                .sheet(isPresented: $showDishPicker) {
                    DishPickerView { dish in
                        addEatenMeal(dish: dish)
                    }
                }

            }
            .navigationTitle("Учёт питания")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showMenu.toggle() }) {
                        Image(systemName: "line.3.horizontal")
                    }
                }
            }
            .sheet(isPresented: $showMenu) {
                SideMenuView()
            }
            .onAppear { loadMeals(for: selectedDate) }
            .onChange(of: selectedDate) { newDate in
                loadMeals(for: newDate)
            }
        }
    }

    // MARK: - Fetch meals for date
    private func loadMeals(for date: Date) {
        let dayStart = Calendar.current.startOfDay(for: date)
        let dayEnd = Calendar.current.date(byAdding: .day, value: 1, to: dayStart)!

        let descriptor = FetchDescriptor<EatenMeal>(
            predicate: #Predicate { meal in
                meal.date >= dayStart && meal.date < dayEnd
            },
            sortBy: [SortDescriptor(\EatenMeal.time, order: .reverse)]
        )

        if let result = try? context.fetch(descriptor) {
            eatenMeals = result
        }
    }

    // MARK: - Date change
    private func changeDay(_ offset: Int) {
        if let newDate = Calendar.current.date(byAdding: .day, value: offset, to: selectedDate) {
            selectedDate = Calendar.current.startOfDay(for: newDate)
        }
    }

    // MARK: - Formatters
    private func dateString(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ru_RU")
        f.dateFormat = "d MMM yyyy"
        return f.string(from: date)
    }

    private func timeString(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: date)
    }

    // MARK: - Total calories
    private var totalCalories: Int {
        eatenMeals.reduce(0) { $0 + $1.dish.calories }
    }

    // MARK: - Delete eaten meal
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            context.delete(eatenMeals[index])
        }
        eatenMeals.remove(atOffsets: offsets)
    }

    // MARK: - Add eaten meal
    private func addEatenMeal(dish: Dish) {
        let record = EatenMeal(
            date: selectedDate,
            dish: dish
        )
        context.insert(record)
        loadMeals(for: selectedDate)
    }
}

#Preview {
    DayView()
        .modelContainer(for: [Dish.self, EatenMeal.self])
}
