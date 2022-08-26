//
//  OnboardingView.swift
//  TU-Mobile-App
//
//  Created by Boone on 11/11/21.
//
import Combine
import SwiftUI

struct OnboardingView: View {
    
    @ObservedObject var loginViewModel: LoginViewModel
    
    @State var visible = false
    @State var selection: Int? = nil
    @State var selection2: Bool? = nil
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @State var isNavigationBarHidden: Bool = true
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                if self.status {
                    TabBar()
                } else {

                    ZStack {
                        
                        VStack {
                            
                            Image("TULogo")
                                .resizable()
                                .frame(width: 200, height: 200)
                            
                            Text("Log into your account")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.top, 35)
                            
                            TextField("Email", text: $loginViewModel.email)
                                .autocapitalization(.none)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 4).stroke(loginViewModel.email != "" ? Color(.red) :
                                    Color.black.opacity(0.7),lineWidth: 2))
                                .padding(.top, 25)
                            
                            //Password
                            HStack(spacing: 15) {
                                
                                VStack {
                                    
                                    if self.visible {
                                        TextField("Password", text: $loginViewModel.password)
                                    } else {
                                        SecureField("Password", text: $loginViewModel.password)
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
                            .background(RoundedRectangle(cornerRadius: 4).stroke(loginViewModel.password != "" ? Color(.red) :
                                Color.black.opacity(0.7),lineWidth: 2))
                            .padding(.top, 25)
                            
                            //MARK: TODO - Forgot Password
                            HStack {

                                Spacer()

                                Button(action: {
                                    

                                }, label: {

                                    Text("Forgot Password")
                                        .fontWeight(.bold)
                                })

                            }
                            .padding(.top, 20)
                            
                            //Log-in Button
                            Button(action: {

                                loginViewModel.verify()

                            }) {

                                Text("Log in")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                            }
                            .background(Color.getCustomColor(.TUBlue))
                            .cornerRadius(10)
                            .padding(.top, 25)
                            
                            Divider()
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                            
                            //Create Account Button
                            NavigationLink(destination: CreateAccountView(createAccountViewModel: CreateAccountViewModel()), tag: 1, selection: $selection) {
                                
                                Button(action: {
                                    print("Create Acount tapped...")
                                    self.selection = 1
                                }) {

                                    Text("Create Account")
                                        .foregroundColor(.white)
                                        .padding(.vertical)
                                        .frame(width: UIScreen.main.bounds.width - 50)
                                }
                                .background(Color.getCustomColor(.TUGold))
                                .cornerRadius(10)
                            }
                            
                        }
                        .padding(.horizontal, 25)
                        
                        if loginViewModel.alert {
                            
                            ErrorHandlingView(alert: $loginViewModel.alert, error: $loginViewModel.error)
    
                        }
                    }
                }
                
            }
            
            .onAppear() {
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) {
                    (_) in

                    self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false

                }
                
            }
            
        }
        .accentColor(Color(.black))
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(self.isNavigationBarHidden)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            self.isNavigationBarHidden = true
        }
    }
}
