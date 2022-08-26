//  TestView.swift
//  TU-Mobile-App
//
//  Created by David Montgomery on 11/9/21.
//

import SwiftUI

struct TestView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var SearchedNames = ""
    @State var isSearching = false
    @State var isNameClicked = false
    @State var isCheckMark = false
    @Binding var clickedNames: [String]
    @Binding var isSelected: Bool
    @Binding var addTest: Bool

    @ObservedObject var networkViewModel: NetworkViewModel
    @ObservedObject var names: ModalViewModel


    var body: some View {
        NavigationView {
            ScrollView {
                VStack {

                    //Search Bar
                    HStack {
                        HStack {
                        TextField("Search students here", text: $SearchedNames )
                            .padding(.leading, 24)
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .onTapGesture(perform: {
                        isSearching = true
                    })
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Spacer()
                            if isSearching {
                                Button(action: {SearchedNames = ""}, label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .padding(.vertical)
                                })

                            }
                        }.padding(.horizontal, 32)
                        .foregroundColor(.gray)
                    ).transition(.move(edge: .trailing))
                    .animation(.spring())
                    if isSearching {
                        Button(action: {
                            isSearching = false
                            SearchedNames = ""

                        }, label: {
                            Text("Cancel")
                                .padding(.trailing)
                                .padding(.leading, 0)
                        })
                        .transition(.move(edge: .trailing))
                        .animation(.spring())
                    }

                }
                    .onAppear() {
                        self.networkViewModel.getAllUsers()

                    }

                    // Displays Users
                    ForEach((networkViewModel.allUsersInDatabase).filter({ "\($0)".contains(SearchedNames) || SearchedNames.isEmpty }), id: \.self) { entry in

                        ListThing(modalViewModel: names, firstName: entry.fName, lastName: entry.lName, clickedNames: clickedNames, isSelected: $isSelected, addTest: $addTest )

                        Divider()
                            .background(Color(.systemGray4))
                            .padding(.leading)
                    }
                }
            }
            .navigationBarTitle("Students")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if names.areNamesClicked {
                        Button("Add", action: {
                            clickedNames = names.names

                            let _ = print(names.names)
                            self.presentationMode.wrappedValue.dismiss()
                        })
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if addTest {
                        Button("Modify", action: {
                            clickedNames = names.names

                            let _ = print(names.names)
                            self.presentationMode.wrappedValue.dismiss()
                        })
                    }
                }
                ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button("Dismiss", action: {
                            self.presentationMode.wrappedValue.dismiss()
                        })
                }
            }

        }
    }
}

struct ListThing: View {

    @ObservedObject var modalViewModel: ModalViewModel

    @State var firstName: String
    @State var lastName: String
    //@State var name: String = ""
    @State var clickedNames: [String]
    @Binding var isSelected: Bool
    @State var isBlue: Bool = false
    @Binding var addTest: Bool

    var body: some View {
            HStack {
                let name = "\(firstName) \(lastName)"
                Text(name)

                Spacer()
                //ModalViewModel.containsToo(name: firstName)
                //Image(systemName: "checkmark")
            }
            .foregroundColor(isBlue ? Color.blue : Color.black)
            .contentShape(Rectangle())
            .onTapGesture {
                let name = "\(firstName) \(lastName)"
                isBlue.toggle()
                //blue check
                if (clickedNames.contains(name)) {
                    if let index = clickedNames.firstIndex(of: name) {
                        clickedNames.remove(at: index)
                    }
                    addTest = true
                    modalViewModel.areNamesClicked = false
                    modalViewModel.add(name: name)
                }
                //nothin
                else {
                modalViewModel.areNamesClicked = isSelected
                modalViewModel.add(name: name)
                //let _ = print(ModalViewModel.names)
                }

            }
            .onAppear() {
                let name = "\(firstName) \(lastName)"
                if (clickedNames.contains(name)) {
                    isBlue = true
                    modalViewModel.add(name: name)

                }
                else {
                    isBlue = false
                    //isSelected.toggle()
                }
            }
            .padding()


    }
}


//struct TestView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestView(viewModel: UsersViewModel(), names: ModalViewModel())
