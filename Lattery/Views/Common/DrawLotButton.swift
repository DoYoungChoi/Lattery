//
//  DrawLotButton.swift
//  Lattery
//
//  Created by dodor on 2023/07/13.
//

import SwiftUI
import Combine

enum Paw: String, Identifiable, CaseIterable {
    case pink = "삥꾸발바닥"
    case black = "까망발바닥"
    
    var id: String { rawValue }
    var color: Color {
        switch (self) {
            case .pink: return .customPink
            case .black: return .customDarkGray
        }
    }
}

struct DrawLotButton: View {
    @Binding var isRunning: Bool
    @Binding var isEnded: Bool
    var action: () -> ()
    @State private var showPawPicker: Bool = false
    @State private var paw: Paw = .pink
    @State private var timer: Timer?
    
    var body: some View {
        let longPressGesture = LongPressGesture(minimumDuration: 0.01)
            .onEnded { _ in
                fireTimer()
            }

        VStack {
            Spacer()
            
            HStack {
                if showPawPicker {
                    PawPicker(selection: $paw)
                }
                
                Spacer()
                
                Button {
                    withAnimation { showPawPicker.toggle() }
                } label: {
                    Image(systemName: "pawprint.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 25)
                        .foregroundColor(.customDarkGray)
                }
                .padding(.top, 3)
            }
            
            PawButton(paw: paw)
                .opacity(isRunning ? 0.5 : 1)
                .scaleEffect(isRunning ? 0.95 : 1)
                .simultaneousGesture(longPressGesture)
                .disabled(isRunning)
                .animation(.easeOut(duration: 0.1), value: isRunning)
        }
        .aspectRatio(CGSize(width: 1, height: 1.1), contentMode: .fit)
        .onDisappear {
            invalidateTimer()
        }
    }
    
    private struct PawPicker: View {
        @Binding var selection: Paw
        
        var body: some View {
            HStack {
                ForEach(Paw.allCases) { type in
                    VStack(spacing: 0) {
                        Text(type.id)
                            .padding(.vertical, 3)
                        
                        Rectangle()
                            .frame(height: 3)
                            .foregroundColor(.customPink)
                            .opacity(selection == type ? 1 : 0)
                    }
                    .background(.background)
                    .opacity(selection == type ? 1 : 0.3)
                    .onTapGesture {
                        withAnimation { selection = type }
                    }
                }
            }
        }
    }
    
    private func fireTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
        isRunning.toggle()
        var times = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            action()
            times += 1
            
            if times > 30 {
                invalidateTimer()
                isRunning.toggle()
                isEnded.toggle()
            }
        }
    }
    
    private func invalidateTimer() {
        if timer != nil && timer!.isValid {
            timer!.invalidate()
        }
        timer = nil
    }
}

struct PawButton: View {
    var paw: Paw
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("paw_background")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width)
                
                if paw == .pink {
                    Image("paw_pink")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.9)
                        .offset(x: -geo.size.width * 0.005, y: -geo.size.height * 0.03)
//                        .shadow(color: .customGray, radius: 3, y: 3)
                } else {
                    Image("paw_black")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.9)
                        .offset(x: -geo.size.width * 0.005, y: -geo.size.height * 0.03)
                }
            }
        }
    }
}

struct DrawLotButton_Previews: PreviewProvider {
    static var previews: some View {
        DrawLotButton(isRunning: .constant(false), isEnded: .constant(true)) {
            print("Hey~")
        }
    }
}
