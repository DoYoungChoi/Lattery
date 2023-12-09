//
//  BuyDaySheet.swift
//  Lattery
//
//  Created by dodor on 12/9/23.
//

import SwiftUI

struct BuyDaySheet: View {
    @EnvironmentObject var notiManager: NotificationManager
    private let weekdays = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"]
    @State private var time: Date = Date.now
    @State private var selectedWeekdays: [Int] = [1]
    
    var body: some View {
        VStack {
            HStack {
                Button("닫기") { notiManager.showBuyDaySheet = false }
                Spacer()
                Button("저장") {
                    if notiManager.targetNoti == .lottoBuy {
                        notiManager.lottoBuyTime = time
                        if selectedWeekdays.count > 0 {
                            notiManager.lottoBuyDay = selectedWeekdays
                            notiManager.changeLottoBuyNoti()
                        } else {
                            notiManager.lottoBuyNotiOn = false
                        }
                    } else if notiManager.targetNoti == .pensionBuy {
                        notiManager.pensionBuyTime = time
                        if selectedWeekdays.count > 0 {
                            notiManager.pensionBuyDay = selectedWeekdays
                            notiManager.changePensionBuyNoti()
                        } else {
                            notiManager.pensionBuyNotiOn = false
                        }
                    }
                    notiManager.showBuyDaySheet = false
                }
            }
            .padding(.horizontal)
            
            VStack(spacing: 0) {
                HStack {
                    Text("반복 주기")
                    Spacer()
                    Text("매주")
                        .foregroundColor(.accentColor)
                }
                .padding()
                .background(Color.pureBackground)
                
                Divider()
                
                HStack {
                    Text("다음 시간마다")
                    Spacer()
                    Text("\(time.toTimeKor)")
                        .foregroundColor(.accentColor)
                }
                .padding(.top)
                .padding(.horizontal)
                .background(Color.pureBackground)
                
                DatePicker("",
                           selection: $time,
                           displayedComponents: [.hourAndMinute])
                .datePickerStyle(.wheel)
                .background(Color.pureBackground)
            }
            .cornerRadius(10)
            
            VStack(spacing: 0) {
                ForEach(Array(weekdays.enumerated()), id:\.offset) { (index, weekday) in
                    Button {
                        if selectedWeekdays.contains(index+1) {
                            selectedWeekdays.removeAll(where: { $0 == index+1 })
                        } else {
                            selectedWeekdays.append(index+1)
                        }
                    } label: {
                        HStack {
                            Text(weekday)
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                                .opacity(selectedWeekdays.contains(index+1) ? 1 : 0)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .background(Color.pureBackground)
                    }
                    .buttonStyle(.plain)
                    
                    if index != weekdays.count - 1 {
                        Divider()
                    }
                }
            }
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .background(Color.backgroundGray)
        .onAppear {
            if notiManager.targetNoti == .lottoBuy {
                time = notiManager.lottoBuyTime
                selectedWeekdays = notiManager.lottoBuyDay
            } else if notiManager.targetNoti == .pensionBuy {
                time = notiManager.pensionBuyTime
                selectedWeekdays = notiManager.pensionBuyDay
            }
        }
    }
}

#Preview {
    BuyDaySheet()
}
