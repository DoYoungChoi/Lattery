//
//  LottoDrawLotView.swift
//  Lattery
//
//  Created by dodor on 2023/07/03.
//

import SwiftUI

struct LottoDrawLotView: View {
    @EnvironmentObject var data: LottoData
    @State private var isPressed: Bool = false
    @State private var isEditing: Bool = false
    @State private var paw: Paw = .pink
    private enum Paw: String, Identifiable, CaseIterable {
        case pink = "Pink"
        case black = "Black"
        case spotted = "Spotted"
        
        var id: String { rawValue }
        var description: String {
            switch (self) {
                case .pink:
                    return "삥꾸발바닥"
                case .black:
                    return "까망발바닥"
                case .spotted:
                    return "점박이발바닥"
            }
        }
    }
    @State private var showNumberBoard: Bool = false
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            if isEditing {
                pawTypePicker
            }
            
            ForEach(LottoGroup.allCases) { group in
                HStack {
                    LottoBallRow(group: group,
                                 showNumberBoard: $showNumberBoard)
                }
            }
            
            Spacer()
            
            pawButton
                .padding()
                .onLongPressGesture {
                } onPressingChanged: { tapped in
                    if tapped {
                        fireTimer()
                    } else {
                        invalidateTimer()
                    }
                }
            
            Spacer()
        }
        .padding()
        .navigationTitle("⭐️로또 번호 추첨⭐️")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem {
                Button {
                    withAnimation { isPressed.toggle() }
                    data.reset()
                    isPressed.toggle()
                } label: {
                    Label("재시작", systemImage: "arrow.counterclockwise")
                        .rotationEffect(Angle(degrees: isPressed ? 0 : 360))
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation { isEditing.toggle() }
                } label: {
                    Label("발바닥", systemImage: isEditing ? "pawprint" : "pawprint.fill")
                }
            }
        }
        .sheet(isPresented: $showNumberBoard) {
            LottoNumberBoard()
        }
    }
    
    private var pawTypePicker: some View {
        Picker("발바닥 타입", selection: $paw) {
            ForEach(Paw.allCases) { type in
                Text(type.description)
                    .font(.custom("GangwonEduPowerExtraBold", size: 15, relativeTo: .subheadline))
                    .tag(type)
            }
        }
        .pickerStyle(.segmented)
        .padding()
    }
    
    private var pawButton: some View {
        Button {
            data.drawLot()
        } label: {
            Circle()
                .foregroundColor(.latteIvory)
                .shadow(color: .latteBrown, radius: 8, y: 8)
                .overlay {
                    Image("\(paw.id)Paw")
                        .resizable()
                        .scaledToFit()
                        .shadow(color: .latteBrown, radius: 3, y: 3)
                        .padding(.bottom)
                        .aspectRatio(0.8, contentMode: .fit)
                }
        }
    }
    
    private func fireTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            data.drawLot()
        }
    }
    
    private func invalidateTimer() {
        if timer != nil {
            timer!.invalidate()
        }
        timer = nil
    }
}

struct LottoDrawLotView_Previews: PreviewProvider {
    static var previews: some View {
        LottoDrawLotView()
            .environmentObject(LottoData())
    }
}
