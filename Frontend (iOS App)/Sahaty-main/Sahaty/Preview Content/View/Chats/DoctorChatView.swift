//
//  DoctorChatView.swift
//  Sahaty
//
//  Created by mido mj on 12/21/24.
//

import SwiftUI
struct DoctorChatView: View {
    let doctor: DoctorModel

    var body: some View {
        VStack {
            Text("محادثة مع \(doctor.name)")
                .font(.title2)
                .padding()

            Spacer()

            Text("ميزة المحادثة تحت التطوير.")
                .foregroundColor(.secondary)
                .font(.headline)

            Spacer()
        }
        .navigationTitle("محادثة")
        .navigationBarTitleDisplayMode(.inline)
    }
}
