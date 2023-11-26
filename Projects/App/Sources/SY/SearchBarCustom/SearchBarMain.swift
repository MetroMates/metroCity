// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import SwiftUI

struct SearchBarMain: View {
    @State private var searchText = ""
    @State private var isSearching = false
    @ObservedObject var LocationVM = LocationViewModel()

    var filteredItems: [StationInfo] {
        if !searchText.isEmpty {
            return LocationVM.stationInfo?.filter { $0.statnNm.localizedCaseInsensitiveContains(searchText) } ?? []
        }
        return []
    }
    
    var body: some View {
        VStack {
            SearchBar(searchText: $searchText, isSearching: $isSearching)
            if !searchText.isEmpty {
                ZStack {
                    List(filteredItems) { item in
                        Text(item.statnNm)
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            
        }
    }
}

struct SearchBar: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool

    var body: some View {
        HStack {
            TextField("Search", text: $searchText, onEditingChanged: { editing in
                isSearching = editing
            })
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(10)

            // textfield에 값이 있을때
            if isSearching {
                Button {
                    searchText = ""
                    isSearching = false
                } label: {
                    Image(systemName: "x.circle")
                        .foregroundColor(.black)
                }
                .padding(.trailing)
                .transition(.move(edge: .trailing))
            } else {
                Image(systemName: "magnifyingglass")
            }
        }
        .padding(.horizontal, 5)
    }
}

struct SearchBarMain_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarMain()
            .previewDisplayName("메인")
        SearchBar(searchText: .constant("apple"), isSearching: .constant(true))
            .previewDisplayName("서치바")
    }
}
