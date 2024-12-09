//
//  ContentView.swift
//  Yournal
//
//  Created by Tran Loc on 5/12/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var cameraManager = CameraManager()
    
    var body: some View {
        TabView {

            // Auth View
            // AuthView()
            //     .tabItem {
            //         Label("Auth", systemImage: "person")
            //     }

            // Camera/Main Tab
            MainView()
                .tabItem {
                    Label("Camera", systemImage: "camera")
                }
            
            // Moments List Tab
            NavigationView {
                MomentListView()
            }
            .tabItem {
                Label("Moments", systemImage: "photo.stack")
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Moment.self, inMemory: true)
}
