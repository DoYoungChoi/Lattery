//
//  PensionResultCheckView.swift
//  Lattery
//
//  Created by dodor on 2023/08/09.
//

import SwiftUI

struct PensionResultCheckView: View {
    @EnvironmentObject var viewModel: GeneralViewModel
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.round, order: .reverse)
    ]) var pensions: FetchedResults<PensionEntity>
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.date, order: .reverse)
    ]) var saves: FetchedResults<PensionResult>
    @State private var selectedPension: PensionEntity?
    @State private var selectedSave: PensionResult?
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: - 연금복권 발표 시간 안내
            HStack {
                Image(systemName: "speaker.wave.2")
                Text("매주 목요일 오후 7시 5분경 발표")
                Spacer()
            }
            .foregroundColor(.customGray)
            
            // MARK: - 연금복권 회차 선택
            HStack {
                Text("회차 바로가기")
                    .bold()
                
                Spacer()
                
                if pensions.count > 0 {
                    Picker("", selection: $selectedPension) {
                        ForEach(pensions, id: \.self) { pension in
                            Text(verbatim: "\(pension.round)회")
                                .foregroundColor(.customGray)
                                .tag(Optional(pension))
                        }
                    }
                    .pickerStyle(.menu)
                } else {
                    Text("데이터가 없습니다.")
                        .padding(.vertical, 10)
                        .foregroundColor(.accentColor)
                }
            }
            
            // MARK: - 연금복권 당첨결과 확인
            VStack {
                if let pension = selectedPension {
                    let winNumber = pension.winNumbers ?? ""
                    let bonusNumber = pension.bonusNumbers ?? ""
                    Text(verbatim: "\(pension.round)회 당첨결과")
                        .bold()
                        .font(.title)
                        .foregroundColor(.primary)
                    
                    Text("(\(pension.date?.toDateStringKor ?? "yyyy년 MM월 dd일") 추첨)")
                        .font(.footnote)
                        .foregroundColor(.accentColor)
                    
                    VStack(spacing: 0) {
                        HStack {
                            Text("1등")
                                .font(.callout)
                                .bold()
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            PensionBall(number: pension.winClass, unit: 0)
                            Text("조")
                            ForEach(Array(winNumber.enumerated()), id:\.offset) { (index, char) in
                                PensionBall(number: Int16(String(char)), unit: index+1)
                            }
                        }
                    }
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.background.opacity(0.9))
                    }
                    
                    VStack(spacing: 0) {
                        HStack {
                            Text("보너스")
                                .font(.callout)
                                .bold()
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Text("각 조")
                            ForEach(Array(bonusNumber.enumerated()), id:\.offset) { (index, char) in
                                PensionBall(number: Int16(String(char)), unit: index+1)
                            }
                        }
                    }
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.background.opacity(0.9))
                    }
                } else {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.customYellow)
                            .imageScale(.large)
                        Text("연금복권 회차를 선택하세요")
                            .font(.title2)
                    }
                    .padding(.top, 5)
                    
                    Text("데이터가 없는 경우 새로고침 버튼으로 데이터를 가져오거나, 'My메뉴'>'설정'으로 이동하여 네트워크 상에서 '연금복권 데이터 가져오기'를 실행하세요.\n그 외 문제 발생 시 개발자에게 문의하세요.")
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
            Text("저장한 연금복권 추첨번호")
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
                PensionNumberCheckView(entity: save, winInfo: selectedPension)
            }
            
            Spacer()
        }
        .onAppear {
            selectedPension = pensions.first ?? nil
            selectedSave = saves.first ?? nil
        }
        .onChange(of: viewModel.isLoading) { value in
            if value == false {
                selectedPension = pensions.first ?? nil
            }
        }
    }
}

struct PensionResultCheckView_Previews: PreviewProvider {
    static var previews: some View {
        PensionResultCheckView()
    }
}
