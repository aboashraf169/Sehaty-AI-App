//
//  AppState.swift
//  Sahaty
//
//  Created by mido mj on 12/22/24.
//


import SwiftUI

class AppState: ObservableObject {
    @Published var selectedTabDoctors: TabDoctor = .home
    @Published var selectedTabPatients: TabPatient = .home

}

enum TabPatient {
    case home
    case chat
    case Doctors
    case settings
    case Notificatons
}

enum TabDoctor {
    case home
    case chat
    case profile
    case settings
    case Notificatons
}
