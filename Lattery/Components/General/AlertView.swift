//
//  AlertView.swift
//  Lattery
//
//  Created by dodor on 12/15/23.
//

import SwiftUI

struct AlertView: View {
    
    let title: String
    let content: String?
    var doLabel: String = "실행"
    let closeAction: () -> Void
    var doAction: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
            
            VStack(spacing: 0) {
                Group {
                    Text(title)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color.primaryColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    if let content {
                        Text(content)
                            .font(.system(size: 14))
                            .foregroundStyle(Color.gray3)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                    }
                }
                
                Divider()
                    .padding(.top, 8)
                
                HStack {
                    Button(action: closeAction) {
                        HStack {
                            Spacer()
                            Text("확인")
                                .font(.system(size: 17))
                            Spacer()
                        }
                        .padding(.vertical, 12)
                    }
                    .clipShape(Rectangle())
                    
                    if let doAction {
                        Divider()
                        
                        Button(action: doAction) {
                            HStack {
                                Spacer()
                                Text(doLabel)
                                    .font(.system(size: 17))
                                Spacer()
                            }
                            .padding(.vertical, 12)
                        }
                        .clipShape(Rectangle())
                    }
                }
                .frame(height: 41)
            }
            .frame(maxWidth: 280)
            .background(Color.backgroundGray)
            .cornerRadius(12)
        }
        .ignoresSafeArea()
    }
}
