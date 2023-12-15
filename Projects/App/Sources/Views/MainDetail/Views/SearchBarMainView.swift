// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import SwiftUI

struct SearchBarMainView: View {
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
                        mainDetailVM.getStationTotal(subwayNm: item.subwayNm)
                        mainDetailVM.findStationColor(subwayNm: item.subwayNm)
                        mainDetailVM.selectedStationBorderColor = mainDetailVM.searchColor
                    }
                }
                .listStyle(.plain)
                .frame(height: 130)
            }
        }
    }
    
    private func outFocused() {
        mainDetailVM.searchText = ""
    }
    
}

extension SearchBarMainView {
    @ViewBuilder private var SearchBar: some View {
        
        HStack {
            TextField("역명 검색",
                      text: $mainDetailVM.searchText,
                      onEditingChanged: { edited in
                mainDetailVM.isSearching = edited
            })
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(10)

            Spacer()
            if !mainDetailVM.searchText.isEmpty {
                Button {
                    outFocused()
                } label: {
                    Image(systemName: "x.circle")
                        .foregroundColor(.gray)
                        
                }
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
