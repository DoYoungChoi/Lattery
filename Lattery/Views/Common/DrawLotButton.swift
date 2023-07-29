//
//  DrawLotButton.swift
//  Lattery
//
//  Created by dodor on 2023/07/13.
//

import SwiftUI
import Combine

struct DrawLotButton: View {
    var action: () -> ()
    @State private var showPawPicker: Bool = false
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
    @State private var timer: Timer?
    
    var body: some View {
        let longPressGesture = LongPressGesture(minimumDuration: 0.01)
            .onEnded { _ in
                fireTimer()
            }

        VStack {
            HStack(alignment: .top) {
                if showPawPicker {
                    Picker("발바닥 타입", selection: $paw) {
                        ForEach(Paw.allCases) { type in
                            Text(type.description)
                                .font(.subheadline)
                                .tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom)
                }
                
                Spacer()
                
                Button {
                    withAnimation { showPawPicker.toggle() }
                } label: {
                    Image(systemName: showPawPicker ? "pawprint" : "pawprint.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 25)
                }
                .padding(.top, 3)
            }
            
            Spacer()
            
            Button {
                action()
                invalidateTimer()
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
            .simultaneousGesture(longPressGesture)
        }
    }
    
    private func fireTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            action()
        }
    }
    
    private func invalidateTimer() {
        if timer != nil {
            timer!.invalidate()
        }
        timer = nil
    }
}

struct DrawLotButton_Previews: PreviewProvider {
    static var previews: some View {
        DrawLotButton() {
            print("Hey~")
        }
    }
}
