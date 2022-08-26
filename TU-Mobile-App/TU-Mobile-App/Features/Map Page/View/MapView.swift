//
//  MapView.swift
//  TU-Mobile-App
//
//  Created by David Montgomery on 11/7/21.
//

import SwiftUI
import CoreLocation
import MapKit
import Firebase
import FirebaseFirestore
import Firebase


struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @ObservedObject var annotationItems =  PinLocationsViewModel()
    
    
    var body: some View {
        Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: annotationItems.annotationItems) {item in
            MapPin(coordinate: item.coordinate)
            
        }
                .ignoresSafeArea()
                .overlay(addView(), alignment: .bottomTrailing)
                //.accentColor(Color(.systemPink))
                .onAppear {
                    viewModel.checkIfLocationServicesIsEnabled()
                }
    }
}
//struct MapView_Previews: PreviewProvider {
//    @Binding var isSelected: Bool
//    static var previews: some View {
//        MapView(isSelected: $isSelected)
//    }
//}

struct addView: View {
    @State var showModal = false
    @State var dummy = false
    @State var clickedNames: [String] = [""]
    //@Binding var isSelected: Bool
    @State var isSelected: Bool = false
    var body: some View {

        HStack(alignment: .bottom){

            Image(systemName: "square.and.arrow.up")
                .padding(.bottom)
                .padding(.bottom)
                .font(.largeTitle)
                //.padding()

            Button(action: {showModal = true}) {
            Image(systemName: "plus.circle.fill")
                .foregroundColor(.black)
                .padding(.bottom)
                .padding(.bottom)
                .padding(.trailing)
                .font(.largeTitle)
                //.padding()

            }
            .sheet(isPresented: $showModal, content: {
                ShapeViewSettings(names: ModalViewModel(), clickedNames: $clickedNames, isSelected: $isSelected)
            })
        }
    }
}

struct ShapeViewSettings: View {

    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    @State private var curHeight: CGFloat = 400
    @State var EventTitle: String = ""
    @State var EventLocation: String = ""
    @State var EventRoomNumber: String = ""
    @State var showModal = false
    @ObservedObject var names: ModalViewModel
    @Binding var clickedNames: [String]
    @Binding var isSelected: Bool
    @State var addTest: Bool = false
    @State var EventTitleFilled: Bool = false
    @State var EventDate = Date()
    @State var EventStartTime = Date()
    @State var EventEndTime = Date()
    @State var searchedLocations = ""
    @ObservedObject var pinLocationsViewModel = PinLocationsViewModel()
    public var db = Firestore.firestore()

    var body: some View {

        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Title of event")) {
                        TextField("", text: $EventTitle)
                        //areTextFieldsEmpty(field: $EventTitle, EventTitleFilled: $EventTitleFilled)
                    }
                    Section {
                    DatePicker("Event date", selection: $EventDate, in: Date()..., displayedComponents: .date)
                    }
                    Section {
                        DatePicker("Start time", selection: $EventStartTime, displayedComponents: .hourAndMinute)
                    }
                    Section {
                    DatePicker("End time", selection: $EventEndTime, displayedComponents: .hourAndMinute)
                    }
                    Section(header: Text("Location")) {
                        TextField("", text: $EventLocation)
                    }
                    Section(header: Text("Room number")) {
                        TextField("", text: $EventRoomNumber)
                    }
                    Section(header: Text("Add participants")) {
                        Button(action: {showModal = true}) {
                        Image(systemName: "person.crop.circle.fill.badge.plus")
                            .foregroundColor(.black)
                            .font(.largeTitle)
                        }
                        List(clickedNames, id: \.self) {name in
                            HStack {
                                Text(name)

                                Spacer()
                            }
                            .padding()
                        }
                        .sheet(isPresented: $showModal, content: {
                            TestView(clickedNames: $clickedNames, isSelected: $isSelected, addTest: $addTest, networkViewModel: NetworkViewModel(), names: ModalViewModel())
                        })




                    }

                }
                .navigationBarTitle("Create an event")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                            Button("Dismiss", action: {
                                self.presentationMode.wrappedValue.dismiss()
                            })
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Button("Add", action: {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "HH:mm:ss"

                                let startResult = dateFormatter.string(from: EventStartTime)
                                var ref: DocumentReference? = nil

                                let endResult = dateFormatter.string(from: EventEndTime)
                                ref = db.collection("events").addDocument(data: [
                                    "eventtitle": EventTitle,
                                    "eventdate": EventDate,
                                    "eventstarttime": startResult,
                                    "eventendtime": endResult,
                                    "location": EventLocation,
                                    "roomnumber": EventRoomNumber,
                                    "participants": clickedNames


                                ]) { err in
                                    if let err = err {
                                        print("Error adding document: \(err)")
                                    }
                                    else {
                                        print("Document added with ID: \(ref!.documentID)")
                                    }
                                }
                                self.presentationMode.wrappedValue.dismiss()
                            })
                        }
                    }
                }


                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                        Rectangle()
                            .frame(height: curHeight / 2)
                    }
                    .foregroundColor(.white)
                )
        }
    }
}
