//
//  CustomTabBar.swift
//  Exercism
//
//  Created by Angie Mugo on 15/08/2023.
//

import SwiftUI

public enum TabBarPosition {
    case top
    case bottom
}

public struct CustomTabView<TabItem: Tabbable, Content: View>: View {
    private let selectedItem: TabBarSelection<TabItem>
    private var tabBarPosition: TabBarPosition
    private let content: Content
    @State private var items: [TabItem]
    let gradientColors = [Color.appAccent.opacity(0.4),
                                     Color.appAccent.opacity(0.6),
                                     Color.appAccent.opacity(0.8),
                                     Color.appAccent]

    public init(selectedItem: Binding<TabItem>,
                tabBarPosition: TabBarPosition = .top,
                @ViewBuilder content: () -> Content) {
        self.selectedItem = .init(selection: selectedItem)
        self.content = content()
        self.tabBarPosition = tabBarPosition
        self._items = .init(initialValue: .init())
    }

    public var tabItems: some View {
        HStack(spacing: 0) {
            ForEach(self.items, id: \.self) { item in
                HStack {
                    Image(systemName: item.icon)
                    Text(item.title)
                    Divider().frame(width: 2)
                }
                .padding(.leading)
                .background(selectedItem.selection == item ? .appAccent : .clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedItem.selection = item
                    selectedItem.objectWillChange.send()
                }
            }
            Spacer()
        }.frame(maxHeight: 50.0)
            .frame(maxWidth: .infinity)

    }

    public var body: some View {
        Group {
            if tabBarPosition == .top {
                VStack(spacing: 0) {
                    Spacer()
                    Divider().frame(height: 2)
                    tabItems
                    Divider().frame(height: 2)
                    ZStack {
                        content.frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .environmentObject(selectedItem)
            } else {
                VStack(spacing: 0) {
                    ZStack {
                        content
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    tabItems
                }
                .environmentObject(selectedItem)
            }
        }.onPreferenceChange(TabBarPreferenceKey.self) { value in
            items = value
        }
    }

}
