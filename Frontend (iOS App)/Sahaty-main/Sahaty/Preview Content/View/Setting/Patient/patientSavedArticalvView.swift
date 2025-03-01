//
//  patientSavedArticalvView.swift
//  Sahaty
//
//  Created by mido mj on 12/24/24.
//

import SwiftUI

struct patientSavedArticalvView: View {
    
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة
    @ObservedObject var patientViewModel : PatientSettingViewModel
    @StateObject var articalsViewModel =  ArticalsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(articalsViewModel.savedArticals) { savedArticals in
                        ArticleView(articleModel: savedArticals, articalViewModel: articalsViewModel, usersType: .patient, pathImgArtical: savedArticals.img ?? ""
                                    ,pathImgDoctor: savedArticals.doctor.img ?? "")
                    }
                }
            }
            .navigationTitle("saved_articles".localized())
            .navigationBarTitleDisplayMode(.inline)
        }
        .direction(appLanguage)
        .environment(\.locale, .init(identifier: appLanguage))
        .onAppear {
            articalsViewModel.fetchArticalSaved()
        }


    }
}

#Preview {
    patientSavedArticalvView(patientViewModel: PatientSettingViewModel(), articalsViewModel: ArticalsViewModel())
}

