//
//  NotificationsView.swift
//  Sahaty
//
//  Created by mido mj on 12/25/24.
//

import SwiftUI

struct doctorNotificationsView: View {
    @StateObject private var viewModel = doctorNotificationViewModel()
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.notifications.isEmpty {
                    noNotificationsView
                } else {
                    List(viewModel.notifications,id: \.self) { notification in
                        HStack(alignment: .top, spacing: 10) {
                            // أيقونة الإشعار
                            Image(systemName: "bell.badge.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.accent)
                                .frame(width: 30, height: 30)

                            // تفاصيل الإشعار
                            VStack(alignment: .leading, spacing: 5) {
                                Text(notification.title)
                                    .font(.subheadline)

                                Text(notification.description)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)

                                Text(notification.created_at)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .lineLimit(nil)
                                    .padding(.top, 10)
                            }
                        }
                        .padding(8)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("notifications".localized()) // الإشعارات
            .navigationBarTitleDisplayMode(.inline)
            .direction(appLanguage) // ضبط اتجاه النصوص
            .environment(\.locale, .init(identifier: appLanguage)) // اللغة المختارة
        }
        .onAppear {
            viewModel.loadDefaultNotifications()
        }
    }

    // MARK: - No Notifications View
    private var noNotificationsView: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray.opacity(0.7))
            
            Text("no_notifications".localized()) // لا توجد إشعارات
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            Text("no_notifications_message".localized()) // ستظهر الإشعارات هنا عند توفرها.
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.top)
    }
}

#Preview {
    doctorNotificationsView()
}
