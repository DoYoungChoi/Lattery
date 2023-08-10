//
//  LottoResultCheckView.swift
//  Lattery
//
//  Created by dodor on 2023/08/09.
//

import SwiftUI
import CoreData

struct LottoResultCheckView: View {
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.round, order: .reverse)
    ]) var lottos: FetchedResults<LottoEntity>
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.date, order: .reverse)
    ]) var saves: FetchedResults<LottoResult>
    @State private var selectedLotto: LottoEntity?
    @State private var selectedSave: LottoResult?
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: - 로또 발표 시간 안내
            HStack {
                Image(systemName: "speaker.wave.2")
                Text("매주 토요일 오후 8시 30분경 발표")
                Spacer()
            }
            .foregroundColor(.customGray)
            
            // MARK: - 로또 회차 선택
            HStack {
                Text("회차 바로가기")
                    .bold()
                
                Spacer()
                
                if lottos.count > 0 {
                    Picker("", selection: $selectedLotto) {
                        ForEach(lottos, id: \.self) { lotto in
                            Text(verbatim: "\(lotto.round)회")
                                .foregroundColor(.customGray)
                                .tag(Optional(lotto))
                        }
                    }
                    .pickerStyle(.menu)
                } else {
                    Text("데이터가 없습니다.")
                        .padding(.vertical, 10)
                        .foregroundColor(.accentColor)
                }
            }
            
            // MARK: - 로또 당첨결과 확인
            VStack {
                if let lotto = selectedLotto {
                    Text(verbatim: "\(lotto.round)회 당첨결과")
                        .bold()
                        .font(.title)
                        .foregroundColor(.primary)
                    
                    Text("(\(lotto.date?.toDateStringKor ?? "yyyy년 MM월 dd일") 추첨)")
                        .font(.footnote)
                        .foregroundColor(.accentColor)
                    
                    HStack(spacing: 10) {
                        VStack(spacing: 5) {
                            HStack {
                                LottoBall(number: lotto.no1)
                                LottoBall(number: lotto.no2)
                                LottoBall(number: lotto.no3)
                                LottoBall(number: lotto.no4)
                                LottoBall(number: lotto.no5)
                                LottoBall(number: lotto.no6)
                            }
                            .padding(10)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.background.opacity(0.9))
                            }
                            
                            Text("당첨번호")
                                .font(.footnote)
                        }
                        
                        Image(systemName: "plus")
                            .foregroundColor(.accentColor)
                            .offset(y: -11)
                        
                        VStack(spacing: 5) {
                            LottoBall(number: lotto.noBonus)
                                .padding(10)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.background.opacity(0.9))
                                }
                            
                            Text("보너스")
                                .font(.footnote)
                        }
                    }
                } else {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.customYellow)
                            .imageScale(.large)
                        Text("ERROR")
                            .font(.title2)
                    }
                    .padding(.top, 5)
                    
                    Text("당첨결과 확인할 로또 회차를 선택하세요.\n당첨 데이터가 없거나 최신 데이터에 문제가 있는 경우 'My메뉴'>'설정'으로 이동하여 네트워크 상에서 '로또 데이터 가져오기'를 실행하거나 앱을 껐다 다시 실행하세요.\n그 외 문제 발생 시 개발자에게 문의하세요.")
                        .lineSpacing(8)
                        .font(.callout)
                        .padding(5)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.backgroundGray)
            }
            
            // MARK: - 저장한 로또추첨번호
            Text("저장한 로또추첨번호")
                .bold()
                .padding(.top, 10)
                
            HStack {
                Spacer()
                if saves.count > 0 {
                    Picker("", selection: $selectedSave) {
                        ForEach(saves, id:\.self) { save in
                            Text("\(save.date?.toDateTimeKor ?? "yy년MM월dd일 HH시mm분") 추첨번호")
                                .foregroundColor(.backgroundGray)
                                .tag(Optional(save))
                        }
                    }
                    .pickerStyle(.menu)
                } else {
                    Text("저장한 추첨번호가 없습니다.")
                        .foregroundColor(.accentColor)
                        .padding(.vertical, 10)
                    Spacer()
                }
            }
            
            // MARK: - 추첨 로또 번호와 비교
            if let save = selectedSave {
                LottoNumberCheckView(entity: save, winInfo: selectedLotto)
            }
            
            Spacer()
        }
        .onAppear {
            selectedLotto = lottos.first ?? nil
            selectedSave = saves.first ?? nil
        }
    }
}

struct LottoResultCheckView_Previews: PreviewProvider {
    static var previews: some View {
        LottoResultCheckView()
    }
}
