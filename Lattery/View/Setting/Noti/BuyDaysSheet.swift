//
//  BuyDaysSheet.swift
//  Lattery
//
//  Created by dodor on 12/14/23.
//

import SwiftUI

struct BuyDaysSheet: View {
    
    @ObservedObject var viewModel: SettingViewModel
    @State private var time: Date = Date()
    @State private var selectedDays: [Int] = []
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button("닫기") {
                    viewModel.send(action: .toggleBuyDaysSheet(viewModel.lotteryType))
                }
                Spacer()
                Button("저장") {
                    viewModel.send(action: .saveBuyDayTime(selectedDays, time))
                }
            }
            
            SelectedTime(time: $time)
            
            SelectedWeekDays(days: $selectedDays)
            
            Spacer()
        }
        .padding(20)
        .background(Color.backgroundGray)
        .onAppear {
            if viewModel.lotteryType == .lotto {
                selectedDays = viewModel.lottoBuyDays
                time = viewModel.lottoBuyTime
            } else {
                selectedDays = viewModel.pensionBuyDays
                time = viewModel.pensionBuyTime
            }
        }
    }
}

private struct SelectedTime: View {
    
    @Binding var time: Date
    
    fileprivate var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("반복 주기")
                    .foregroundStyle(Color.primaryColor)
                Spacer()
                Text("매주")
                    .foregroundStyle(Color.gray2)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            Divider()
            
            HStack {
                Text("다음 시간마다")
                Spacer()
                Text("\(time.toTimeKor)")
                    .foregroundStyle(Color.accentColor)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            DatePicker("",
                       selection: $time,
                       displayedComponents: [.hourAndMinute])
            .datePickerStyle(.wheel)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .background(Color.pureBackground)
        .cornerRadius(10)
    }
}

private struct SelectedWeekDays: View {
    
    @Binding var days: [Int]
    private let weekdays = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"]
    
    fileprivate var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(weekdays.enumerated()), id:\.offset) { (index, weekday) in
                Button {
                    if days.contains(index+1) {
                        days.removeAll(where: { $0 == index+1 })
                    } else {
                        days.append(index+1)
                    }
                } label: {
                    HStack {
                        Text(weekday)
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                            .opacity(days.contains(index+1) ? 1 : 0)
                    }
                    .background(Rectangle().fill(Color.pureBackground))
                }
                .buttonStyle(.plain)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                
                if index != weekdays.count - 1 { Divider() }
            }
        }
        .background(Color.pureBackground)
        .cornerRadius(10)
    }
}

#Preview {
    BuyDaysSheet(viewModel: .init(services: StubService()))
}
