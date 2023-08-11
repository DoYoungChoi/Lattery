//
//  LottoFavoritesView.swift
//  Lattery
//
//  Created by dodor on 2023/08/11.
//

import SwiftUI

struct LottoFavoritesView: View {
    @State var editMode: EditMode = .inactive
    @State var isEditing = false
    @EnvironmentObject var data: LottoData
    @State private var isAdding: Bool = false
    
    var body: some View {
        List {
            ForEach(data.favorites, id:\.self) { numbers in
                HStack {
                    ForEach(numbers.sorted(by: <), id:\.self) { number in
                        LottoBall(number: number)
                    }
                }
                .padding(.vertical, 5)
                .swipeActions {
                    Button(role: .destructive) {
                        data.deleteFavorites(numbers)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .onMove(perform: move)
            
            if data.favorites.count < 1 {
                Button {
                    isAdding = true
                } label: {
                    Text("로또번호 즐겨찾기 추가하기")
                }
            }
        }
        .environment(\.editMode, $editMode)
        .navigationTitle("로또번호 즐겨찾기")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    isAdding = true
                } label: {
                    Image(systemName: "plus")
                }
                
//                EditButton()
                Button {
                    withAnimation {
                        isEditing.toggle()
                        editMode = isEditing ? .active : .inactive
                    }
                } label: {
                    Image(systemName: isEditing ? "pencil.circle" : "pencil")
                }
            }
        }
        .sheet(isPresented: $isAdding) {
            LottoNumberBoard(forFavorite: true)
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        data.favorites.move(fromOffsets: source, toOffset: destination)
        data.saveArrangement()
    }
}

struct LottoFavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        LottoFavoritesView()
    }
}
