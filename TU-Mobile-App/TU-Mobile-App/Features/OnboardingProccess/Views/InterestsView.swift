//
//  InterestsView.swift
//  TU-Mobile-App
//
//  Created by David Montgomery on 11/30/21.
//

import SwiftUI

struct InterestsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var selection: [Int] = Array(repeating:-1,count:15)
    @State var searchedInterests = ""
    @State var isSearching = false
    @Binding var selectedNames: [String]

    @ObservedObject var modalViewModel: ModalViewModel
    
    @State var isPressed: Bool = false
    @State var isSelected: Bool = false
    
    @State private var array = [
        "reading",
        "puzzles",
        "journaling",
        "sketching",
        "painting",
        "drawing",
        "yoga",
        "pilates",
        "stretching",
        "music",
        "writing",
        "sewing",
        "crochet",
        "knitting",
        "baking",
        "cooking" ]
    
    let gridItems = [GridItem(.fixed(150), spacing: 10),
                     GridItem(.fixed(150), spacing: 10),
                     GridItem(.fixed(150), spacing: 10)]
    
    @State var clickedInterests: [String] = []
    
    var body: some View {
        ZStack {
            Color("InterestsBackgroundColor")
                    .ignoresSafeArea()
            VStack {
                Text("Your interests")
                    .font(.system(size: 35))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
                    .frame(height: 15)
                Text("Pick your interests and we will suggest you students at the University of Tulsa who share similar interests as yourself")
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.leading, 50)
                    .padding(.trailing, 50)
            }
            .padding(.bottom, 625)
            ScrollView(.horizontal) {
                LazyHGrid(rows: gridItems) {
                    ForEach(searchResults, id: \.self) { i in
                        Button (action: {
                            if modalViewModel.names.contains(i) {
                                isPressed = true
                            }
                            else {
                                isPressed = false
                            }
                            //isPressed.toggle()
                            if (clickedInterests.contains(i)) {
                                if let index = clickedInterests.firstIndex(of: i) {
                                    clickedInterests.remove(at: index)
                                }
                                modalViewModel.areNamesClicked = false
                                modalViewModel.add(name: i)
                            }
                            else {
                                modalViewModel.areNamesClicked = isSelected
                                modalViewModel.add(name: i)
                            }
                        }, label: {
                            ZStack {
                                //let numOfChar = self.array[i].count
                                Circle()
                                    .strokeBorder(modalViewModel.names.contains(i) == true ? Color.orange: Color.white, lineWidth: 2)
                                    .background(Circle().fill(modalViewModel.names.contains(i) == true ?  Color.orange:Color("InterestsBackgroundColor")))
                                    //.frame(width: numOfChar > 7 ? 140 : CGFloat(20*numOfChar), height: numOfChar > 7 ? 140 : CGFloat(20*numOfChar))
                                    .frame(width: 140)
                                    
                                Text("\(i)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 25))
                                    .fontWeight(.bold)
                                }
                            
                            })
                        .onAppear() {
                            if (clickedInterests.contains(i)) {
                                isPressed = true
                                modalViewModel.add(name: i)
                            }
                            else {
                                isPressed = false
                            }
                        }
                    }
                }
            }
            HStack {
                HStack {
                TextField("Search interests here", text: $searchedInterests )
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
                        Button(action: {searchedInterests = ""}, label: {
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
                    searchedInterests = ""

                }, label: {
                    Text("Cancel")
                        .padding(.trailing)
                        .padding(.leading, 0)
                })
                .transition(.move(edge: .trailing))
                .animation(.spring())
            }

            }
            .padding(.top, 575)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Add", action: {
                    selectedNames = modalViewModel.names

                    self.presentationMode.wrappedValue.dismiss()
                })
            }
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button("Dismiss", action: {
                    self.presentationMode.wrappedValue.dismiss()
                })
            }
        }
        
    }
    
    var searchResults: [String] {
        if searchedInterests.isEmpty {
            return array
        } else {
            return array.filter { $0.localizedCaseInsensitiveContains(searchedInterests) }
        }
    }
}
