//
//  DrawingLotView.swift
//  Lattery
//
//  Created by dodor on 2023/07/03.
//

import SwiftUI

struct DrawingLotView: View {
    @EnvironmentObject var data: DrawingLotData
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            ForEach(data.numberSets.sorted { $0.key < $1.key }, id: \.key) { key, value in
                HStack {
                    Text(key.rawValue)
                        .font(.title)
                        .bold()
                        .padding(.trailing)
                    
                    ForEach(value, id: \.self) { number in
                        LottoBall(number: number)
                    }
                }
            }
            
            pawButton
                .onLongPressGesture {
                } onPressingChanged: { tapped in
                    if tapped {
                        fireTimer()
                    } else {
                        invalidateTimer()
                    }
                }
        }
    }
    
    private var pawButton: some View {
        GeometryReader { geo in
            Button {
                data.drawLot()
            } label: {
                ZStack(alignment: .top) {
                    Capsule()
                        .foregroundColor(.pink)
                        .opacity(0.2)
                        .aspectRatio(CGSize(width: 1, height: 1.05), contentMode: .fit)
                        .frame(height: geo.size.height / 1.4)
                    
                    Circle()
                        .foregroundColor(.pink)
                        .opacity(0.2)
                        .frame(height: geo.size.height / 1.5)
                    
                    Image(systemName: "pawprint.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.pink)
                        .frame(height: geo.size.height / 2)
                        .padding(.top, geo.size.height / 15)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
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

struct DrawingLotView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingLotView()
            .environmentObject(DrawingLotData())
    }
}
