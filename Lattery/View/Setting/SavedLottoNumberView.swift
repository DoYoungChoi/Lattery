//
//  SavedLottoNumberView.swift
//  Lattery
//
//  Created by dodor on 12/9/23.
//

import SwiftUI

struct SavedLottoNumberView: View {
    @Environment(\.managedObjectContext) var moc
//    @EnvironmentObject var data: LottoData
//    @FetchRequest(sortDescriptors: [
//        SortDescriptor(\.date, order: .reverse)
//    ]) var lottos: FetchedResults<LottoResult>

    var body: some View {
        List {
//            ForEach(lottos) { lotto in
//                SavedLottoNumberRow(lotto: lotto)
//                    .padding(5)
//                    .swipeActions {
//                        Button(role: .destructive) {
//                            data.deleteLottoResult(lotto, context: moc)
//                        } label: {
//                            Label("Delete", systemImage: "trash")
//                        }
//                    }
//            }

//            if lottos.count < 1 {
//                Text("저장한 추첨번호가 없습니다.")
//                    .foregroundColor(.accentColor)
//            }
        }
        .navigationTitle("저장한 추첨번호")
        .navigationBarTitleDisplayMode(.large)
    }

    private struct SavedLottoNumberRow: View {
        var lotto: LottoResult

        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                Text("\(lotto.date.toDateTimeKor) 추첨번호")
                    .foregroundColor(.accentColor)
                    .font(.callout)

                HStack {
                    Text("A")
                        .bold()
                        .padding(.trailing, 10)
//                    ForEach(lotto.aGroup?.split(separator: ",") ?? [], id:\.self) { number in
////                        LottoBall1(number: Int16(number))
//                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)

                HStack {
                    Text("B")
                        .bold()
                        .padding(.trailing, 10)
//                    ForEach(lotto.bGroup?.split(separator: ",") ?? [], id:\.self) { number in
////                        LottoBall1(number: Int16(number))
//                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)

                HStack {
                    Text("C")
                        .bold()
                        .padding(.trailing, 10)
//                    ForEach(lotto.cGroup?.split(separator: ",") ?? [], id:\.self) { number in
////                        LottoBall1(number: Int16(number))
//                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)

                HStack {
                    Text("D")
                        .bold()
                        .padding(.trailing, 10)
//                    ForEach(lotto.dGroup?.split(separator: ",") ?? [], id:\.self) { number in
////                        LottoBall1(number: Int16(number))
//                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)

                HStack {
                    Text("E")
                        .bold()
                        .padding(.trailing, 10)
//                    ForEach(lotto.eGroup?.split(separator: ",") ?? [], id:\.self) { number in
////                        LottoBall1(number: Int16(number))
//                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }

    private func deleteLottoResult(at offsets: IndexSet) {
//        for index in offsets {
//            let lotto = lottos[index]
//            moc.delete(lotto)
//        }
//        PersistenceController.shared.save()
    }
}

#Preview {
    SavedLottoNumberView()
}
