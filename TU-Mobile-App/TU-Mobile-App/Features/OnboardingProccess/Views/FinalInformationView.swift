//
//  FinalInformationView.swift
//  TU-Mobile-App
//
//  Created by Boone on 11/11/21.
//
import Combine
import SwiftUI

struct FinalInformationView: View {
    
    @ObservedObject var createAccountViewModel: CreateAccountViewModel
    
    @State var visible = false
    @State var selection: Int? = nil
    @State var addInterests: Bool = false
    
    @Binding var email: String
    @Binding var password: String
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var gender: String
    
    @State var interests: [String] = []
    
    let items = Array(1...6).map({ "Item \($0)" })
    
    let layout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
  
    var body: some View {
            
        ScrollView(.vertical) {
                
                VStack {
                    
                    //Class
                    HStack {
                        
                        Text("Class:")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.trailing, 50)
                        
                        TextField("i.e 2021...", text: $createAccountViewModel.classYear)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(createAccountViewModel.classYear != "" ? Color(.red) :
                                Color.black.opacity(0.7),lineWidth: 2))
                        
                    }
                    .padding(.top, 25)
                    
                    //Major
                    HStack {
                        
                        Text("Major:")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.trailing, 50)
                        
                        TextField("", text: $createAccountViewModel.major)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(createAccountViewModel.major != "" ? Color(.red) :
                                Color.black.opacity(0.7),lineWidth: 2))
                        
                    }
                    .padding(.top, 25)
                    
                    //Minor
                    HStack {
                        
                        Text("Minor:")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.trailing, 50)
                        
                        TextField("", text: $createAccountViewModel.minor)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(createAccountViewModel.minor != "" ? Color(.red) :
                                Color.black.opacity(0.7),lineWidth: 2))
                        
                    }
                    .padding(.top, 25)
                    .padding(.bottom, 25)
                    
                    //Interests
                    HStack {
                        
                        Text("Interests:")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 5)
                    
                    
//                    LazyVGrid(columns: layout, content : {
//                        ForEach(items, id:\.self) { item in
//                            Rectangle()
//                                .fill(Color.blue)
//                                .frame(height: 150)
//                                .cornerRadius(12)
//                                .padding()
//                        }
//                    })
                    NavigationLink(destination: InterestsView(selectedNames: $interests, modalViewModel: ModalViewModel()), isActive: $addInterests) {
                        Button(action: {
                            addInterests.toggle()
                            }, label: {
                                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                    .fill(Color("SettingsButtonColor"))
                                    .frame(width: 150, height: 45)
                                    .overlay(
                                        Text("Add Interests")
                                            .font(.system(size: 15))
                                    )


                            })
                    }
                    
                    if (!interests.isEmpty) {
                        Text("Interests added!")
                    }
                    
                    //Continue Button
                    Button(action: {
                        createAccountViewModel.createNewAccount(userEmail: email, userPassword: password, firstName: firstName, lastName: lastName, gender: gender, classYear: createAccountViewModel.classYear, major: createAccountViewModel.major, minor: createAccountViewModel.minor, interests: interests)
                            
                        if !createAccountViewModel.alert {
                                
                            print("Create Acount tried...")
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
//                    }
                    .padding(.top, 25)
                    
                }
                .padding(.horizontal, 25)
            
                .navigationBarTitle("Final Information")
                
            }
        
    }
}
