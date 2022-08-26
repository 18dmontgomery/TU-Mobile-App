//
//  ErrorHandlingView.swift
//  TU-Mobile-App
//
//  Created by Boone on 11/12/21.
//
import Combine
import SwiftUI

struct ErrorHandlingView: View {
    
    @State var color = Color.black.opacity(0.7)
    
    @Binding var alert : Bool
    @Binding var error : String
    
    var body: some View {
        
        GeometryReader {_ in
            
            VStack {
                
                HStack {
                    
                    Text("Error")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                    
                    Spacer()
                }
                .padding(.horizontal, 25)
                
                Text(self.error)
                    .foregroundColor(self.color)
                    .padding(.top)
                    .padding(.horizontal, 25)
                
                //Cancel Button
                Button(action: {
                    
                    self.alert.toggle()
                    
                }) {
                    
                    Text("Cancel")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                .background(Color(.systemGray))
                .cornerRadius(12)
                .padding(.top, 25)
                
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.white)
            .cornerRadius(15)
        }
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
    }
}
