//
//  AboutYou.swift
//  TU-Mobile-App
//
//  Created by Boone on 11/11/21.
//
import Combine
import SwiftUI

struct AboutYou: View {
    
    @ObservedObject var createAccountViewModel: CreateAccountViewModel
    
    @State var visible = false
    @State var selection: Int? = nil
    
    @Binding var email: String
    @Binding var password: String
  
    var body: some View {
            
            ScrollView {
                
                VStack {
                    
                    TextField("First Name", text: $createAccountViewModel.firstName)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(createAccountViewModel.firstName != "" ? Color(.red) :
                            Color.black.opacity(0.7),lineWidth: 2))
                        .padding(.top, 25)
                    
                    TextField("Last Name", text: $createAccountViewModel.lastName)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(createAccountViewModel.lastName != "" ? Color(.red) :
                            Color.black.opacity(0.7),lineWidth: 2))
                        .padding(.top, 25)
                    
                    TextField("Gender", text: $createAccountViewModel.gender)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(createAccountViewModel.gender != "" ? Color(.red) :
                            Color.black.opacity(0.7),lineWidth: 2))
                        .padding(.top, 25)
                        .padding(.bottom, 25)
                    
                    
                    //Continue Button
                    NavigationLink(destination: FinalInformationView(createAccountViewModel: CreateAccountViewModel(), email: $email, password: $password, firstName: $createAccountViewModel.firstName, lastName: $createAccountViewModel.lastName, gender: $createAccountViewModel.gender), tag: 1, selection: $selection) {
                        
                        Button(action: {
                            
                            print("Leaving \"About You\"...")
                            self.selection = 1
                            
                        }) {

                            Text("Continue")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(Color.getCustomColor(.TUBlue))
                        .cornerRadius(10)
                    }
                    
                }
                .padding(.horizontal, 25)
                
            }
            .navigationBarTitle("About You")
        
    }
}

