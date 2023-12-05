// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import SwiftUI

struct SearchBarMain: View {
    @ObservedObject var mainDetailVM: MainDetailVM

    var body: some View {
        VStack {
            SearchBar
            
            if !mainDetailVM.searchText.isEmpty {
                List(mainDetailVM.filteredItems) { item in
                    HStack(spacing: 10) {
                        Text(item.statnNm)
                        Text("(\(item.subwayNm))")
                    }
                    .foregroundColor(.primary)
                    .onTapGesture {
                        outFocused()
                        mainDetailVM.changeFilteredStationAndLineInfo(item: item)
                    }
                }
                .listStyle(.plain)
            }
        }
        .onDisappear {
            outFocused()
        }
    }
    
    private func outFocused() {
        mainDetailVM.searchText = ""
        mainDetailVM.isSearching = false
    }
    
}

extension SearchBarMain {
    @ViewBuilder private var SearchBar: some View {
        
        HStack {
            TextField("Search",
                      text: $mainDetailVM.searchText,
                      onEditingChanged: { edited in
                mainDetailVM.isSearching = edited
            })
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(10)

            // textfield에 값이 있을때
            if mainDetailVM.isSearching {
                Button {
                    outFocused()
                } label: {
                    Image(systemName: "x.circle")
                        .foregroundColor(.primary)
                }
                .padding(.trailing)
                .transition(.move(edge: .trailing))
            } else {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal, 5)
    }
}

struct SearchBarMain_Previews: PreviewProvider {
    static var previews: some View {
        MainListPreviewView()
    }
}
