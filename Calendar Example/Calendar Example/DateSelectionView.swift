//
//  DateSelectionView.swift
//  Calendar Example
//
//  Created by Andrei Chevozerov on 23.08.2020.
//  Copyright © 2020 Example. All rights reserved.
//

import SwiftUI

struct DateSelectionView: View {

    @Environment(\.presentationMode) var presentationMode

    @State private var day: Int
    @State private var month: Int
    @State private var year: Int
    @State private var daySize: CGFloat = 0.0
    @Binding private var selectedDate: Date

    private let calendar = Calendar.current
    private let yearFormatter: NumberFormatter = {
        let object = NumberFormatter()
        object.usesGroupingSeparator = false
        return object
    }()

    init(selectedDate: Binding<Date>) {
        let date = Date()
        _day = State<Int>(initialValue: calendar.component(.day, from: date))
        _month = State<Int>(initialValue: calendar.component(.month, from: date))
        _year = State<Int>(initialValue: calendar.component(.year, from: date))
        _selectedDate = selectedDate
    }

    var body: some View {
        NavigationView {
            VStack {
                monthView
                    .padding(.bottom, 10.0)
                weekdayView
                Divider()
                dayPickerView
                Spacer()
            }
            .padding()
            .navigationBarTitle("Choose a date", displayMode: .inline)
            .navigationBarItems(
                leading: applyButton,
                trailing: closeButton
            )
        }
    }
}

private extension DateSelectionView {

    var applyButton: some View {
        Button(action: {
            let components = DateComponents(
                calendar: self.calendar,
                year: self.year,
                month: self.month,
                day: self.day
            )
            if let date = self.calendar.date(from: components) {
                self.selectedDate = date
            }
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "checkmark")
        }
    }

    var closeButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark")
        }
    }

    var monthView: some View {
        HStack {
            Spacer()
            Button(action: prevMonth) {
                Image(systemName: "chevron.left.square")
            }
            Text(monthName(for: month))
                .font(.title)
            Button(action: nextMonth) {
                Image(systemName: "chevron.right.square")
            }
            Spacer()
            Button(action: { self.year -= 1 }) {
                Image(systemName: "chevron.left.square")
            }
            Text(yearFormatter.string(for: year) ?? "")
                .font(.title)
            Button(action: { self.year += 1 }) {
                Image(systemName: "chevron.right.square")
            }
            Spacer()
        }
    }

    var weekdayView: some View {
        HStack {
            ForEach(calendar.shortWeekdaySymbols, id: \.self) { weekday in
                Text(weekday)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    var dayPickerView: some View {
        VStack(spacing: 8.0) {
            ForEach(0 ..< 5) { week in
                HStack(spacing: 8.0) {
                    ForEach(1 ..< 8) { weekday in
                        ZStack {
                            DayView(day: (7 * week) + weekday, size: self.daySize, selectedDay: self.$day)
                        }
                        .frame(maxWidth: .infinity)
                        .background(
                            GeometryReader { proxy in
                                Color.clear
                                    .preference(key: SizePreferenceKey.self, value: proxy.size.width - 8.0)
                            }
                        )
                        .onPreferenceChange(SizePreferenceKey.self) {
                            self.daySize = $0
                        }
                    }
                }
            }
        }
    }

    func monthName(for index: Int) -> String {
        calendar.monthSymbols[index - 1]
    }

    func nextMonth() {
        guard month < 12 else { return month = 1 }
        month += 1
    }

    func prevMonth() {
        guard month > 1 else { return month = 12 }
        month -= 1
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0.0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct DateSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DateSelectionView(selectedDate: Binding<Date>(get: { Date() }, set: { _ in }))
    }
}
