//
//  ContentView.swift
//  NavBarAccentColorChange
//
//  Created by Jim Dovey on 10/4/19.
//  Copyright © 2019 Jim Dovey. All rights reserved.
//

import SwiftUI

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter
}()

struct AccentColorPreferenceKey: PreferenceKey {
    typealias Value = Color?
    
    static func reduce(value: inout Color?, nextValue: () -> Color?) {
        guard let next = nextValue() else { return }
        value = next
    }
}

struct ContentView: View {
    @State private var dates = [Date]()
    @State private var navAccentColor: Color? = nil

    var body: some View {
        NavigationView {
            MasterView(dates: $dates)
                .navigationBarTitle(Text("Master"))
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button(
                        action: {
                            withAnimation { self.dates.insert(Date(), at: 0) }
                        }
                    ) {
                        Image(systemName: "plus")
                    }
                )
            DetailView()
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        .accentColor(navAccentColor)
        .onPreferenceChange(AccentColorPreferenceKey.self) {
            self.navAccentColor = $0
        }
    }
}

struct MasterView: View {
    @Binding var dates: [Date]

    var body: some View {
        List {
            ForEach(dates, id: \.self) { date in
                NavigationLink(
                    destination: DetailView(selectedDate: date)
                ) {
                    Text("\(date, formatter: dateFormatter)")
                }
            }.onDelete { indices in
                indices.forEach { self.dates.remove(at: $0) }
            }
        }
    }
}

struct DetailView: View {
    var selectedDate: Date?

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 0.3, green: 0.3, blue: 1.0))
                .edgesIgnoringSafeArea(.all)

            Group {
                if selectedDate != nil {
                    Text("\(selectedDate!, formatter: dateFormatter)")
                        .foregroundColor(.accentColor)
                } else {
                    Text("Detail view content goes here")
                }
            }
        }
        .preference(key: AccentColorPreferenceKey.self, value: Color.white)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
