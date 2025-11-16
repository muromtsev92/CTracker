//
//  EatenMeal.swift
//  FoodTracker
//
//  Created by Sergei Muromtsev on 16.11.2025.
//


import Foundation
import SwiftData

@Model
final class EatenMeal {
    var date: Date         // дата (без времени)
    var time: Date         // точное время добавления
    var dish: Dish         // ссылка на блюдо

    init(date: Date, dish: Dish) {
        self.date = Calendar.current.startOfDay(for: date)
        self.time = date
        self.dish = dish
    }
}
