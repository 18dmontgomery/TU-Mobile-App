//
//  CreateAccountView.swift
//  TU-Mobile-App
//
//  Created by Boone on 11/11/21.
//
import Combine
import SwiftUI

struct CreateAccountView: View {
    
    @ObservedObject var createAccountViewModel: CreateAccountViewModel
    
    @State var visible = false
    @State var selection: Int? = nil
  
    var body: some View {
            
            ZStack {
                
                VStack {
                    
                    Text("Create an Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    TextField("University Email", text: $createAccountViewModel.email)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(createAccountViewModel.email != "" ? Color(.red) :
                            Color.black.opacity(0.7),lineWidth: 2))
                        .padding(.top, 25)
                    
                    //Password
                    HStack(spacing: 15) {
                        
                        VStack {
                            
                            if self.visible {
                                TextField("Password", text: $createAccountViewModel.password)
                            } else {
                                SecureField("Password", text: $createAccountViewModel.password)
                            }
                            
                        }
                        
                        Button( action: {
                            
                            self.visible.toggle()
                            
                        }, label: {
                            Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(Color.black.opacity(0.7))
                        })
                        
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(createAccountViewModel.password != "" ? Color(.red) :
                        Color.black.opacity(0.7),lineWidth: 2))
                    .padding(.top, 25)
                    
                    //Conirm Password
                    HStack(spacing: 15) {
                        
                        VStack {
                            
                            if self.visible {
                                TextField("Confirm Password", text: $createAccountViewModel.confirmPassword)
                            } else {
                                SecureField("Password", text: $createAccountViewModel.confirmPassword)
                            }
                            
                        }
                        
                        Button( action: {
                            
                            self.visible.toggle()
                            
                        }, label: {
                            Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(Color.black.opacity(0.7))
                        })
                        
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(createAccountViewModel.confirmPassword != "" ? Color(.red) :
                        Color.black.opacity(0.7),lineWidth: 2))
                    .padding(.top, 25)
                    .padding(.bottom, 25)
                    
                    
                    //Continue Button
                    NavigationLink(destination: AboutYou(createAccountViewModel: CreateAccountViewModel(), email: $createAccountViewModel.email, password: $createAccountViewModel.password), tag: 1, selection: $selection) {
                        Button(action: {
                                
                            createAccountViewModel.register()
                                
                            if !createAccountViewModel.alert {
                                    
                                print("Continue tapped...")
                                self.selection = 1
                                    
                            }
                                
                        }) {

                            Text("Continue")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(Color.getCustomColor(.TUBlue))
                        .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 25)
                
                if createAccountViewModel.alert {
                    ErrorHandlingView(alert: $createAccountViewModel.alert, error: $createAccountViewModel.error)
                }
                
            }
        
    }
}

