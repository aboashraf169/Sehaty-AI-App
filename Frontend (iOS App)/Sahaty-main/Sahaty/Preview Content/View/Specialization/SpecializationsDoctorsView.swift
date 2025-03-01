import SwiftUI



struct SpecializationsDoctorsView: View {
    
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel = SpecializationViewModel()
    @ObservedObject var patientViewModel : PatientSettingViewModel
    @State private var isExpanded  = false
    @State private var searchText: String = ""
    @AppStorage("appLanguage") private var appLanguage = "ar"
    @State private var expandedSections: [Int: Bool] = [:]
    @State var follower : folower = .AllDoctors

    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: self.$follower) {
                    Text("specialties".localized()).tag(folower.AllDoctors)
                    Text("followers".localized()).tag(folower.AllFollowerDoctors)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(20)
                
                if follower == .AllDoctors {
                    doctorList
                }else{
                    doctorFolowerList
                }
                
            }
            .navigationTitle("doctors".localized())
            .navigationBarTitleDisplayMode(.inline)
            .direction(appLanguage)
            .environment(\.locale, .init(identifier: appLanguage))
        }
        .onAppear {
            viewModel.getSpacialties()
        }
    }
    
    private var doctorList: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.getTranslatedSpecialties()) { data in
                        VStack {
                            // عرض التخصص
                                Button {
                                    if let isExpanded = patientViewModel.expandedSpecializations[data.id] {
                                        // تغيير حالة التوسيع
                                        patientViewModel.expandedSpecializations[data.id] = !isExpanded
                                    } else {
                                        // إذا لم يتم إعداد الحالة مسبقًا
                                        patientViewModel.expandedSpecializations[data.id] = true
                                    }
                                    // جلب البيانات عند التوسيع لأول مرة فقط
                                    if patientViewModel.expandedSpecializations[data.id] == true, patientViewModel.doctorsBySpecialization[data.id] == nil {
                                        patientViewModel.getSpeciatyDoctors(speciatyid: data.id)
                                    }
                                }label: {
                                    HStack {
                                        Text(".\(data.id)")
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                        Text(data.name)
                                            .fontWeight(.light)
                                            .font(.headline)
                                        Spacer()
                                    Image(systemName: patientViewModel.expandedSpecializations[data.id] == true ? "chevron.down" : "chevron.left")
                                            .foregroundStyle(Color.accentColor)

                                }
                            }
                            .padding()
                            .foregroundStyle(Color.primary)
                            // عرض الأطباء إذا تم التوسيع
                            if patientViewModel.expandedSpecializations[data.id] == true {
                                if let doctors = patientViewModel.doctorsBySpecialization[data.id] {
                                    ForEach(doctors) { doctor in
                                        doctorRowData(patientViewModel: patientViewModel, doctor: doctor,
                                                      pathImgDoctor: doctor.img ?? "")
                                        Divider()
                                    }
                                    .padding(.horizontal,30)
                                    
                                } else {
                                    ProgressView("Loading doctors...")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var doctorFolowerList: some View {
        ScrollView{
            LazyVStack{
                ForEach(patientViewModel.doctorFollowers) {doctor in
                    followDoctorRowData(patientViewModel: patientViewModel, doctor: doctor, pathImgDoctor: doctor.img ?? "")
                    Divider()
                }
            }
            .padding(.vertical)
            .padding()
        }.onAppear {
            patientViewModel.getDoctorsFollowers()
        }
    }
}


struct doctorRowData: View {
    @ObservedObject var patientViewModel : PatientSettingViewModel
    @State var doctor : DoctorModel
    var pathImgDoctor : String
    var body: some View {
        HStack {
            HStack(alignment: .center, spacing: 10) {
                if let img =  patientViewModel.doctorImages[doctor.id] {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .shadow(radius: 2)
                        .frame(width: 40, height: 40)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }else{
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.accentColor)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(doctor.name)
                        .font(.headline)
                        .fontWeight(.light)
                    Text(doctor.email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                Button(action: {
                    patientViewModel.actionFollowDoctor(doctorId: doctor.id)
                    patientViewModel.getDoctorsFollowers()
                }) {
                    Text(patientViewModel.doctorsIsFollow[doctor.id] == true ? "Unfollow".localized() : "follow".localized())
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 7)
                        .background(patientViewModel.doctorsIsFollow[doctor.id] == true ? Color.accentColor : Color.accentColor)
                        .cornerRadius(8)
                }
                .onAppear {
                    patientViewModel.doctorImage(from: pathImgDoctor, for: doctor.id)
                }
            }
        }
    }
}

struct followDoctorRowData: View {
    @ObservedObject var patientViewModel : PatientSettingViewModel
    @State var doctor : DoctorModel
    var pathImgDoctor : String
    var body: some View {
        HStack {
            HStack(alignment: .center, spacing: 10) {
                if let img =  patientViewModel.doctorImages[doctor.id] {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .shadow(radius: 2)
                        .frame(width: 40, height: 40)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }else{
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.accentColor)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(doctor.name)
                        .font(.headline)
                        .fontWeight(.light)
                    Text(doctor.email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                Button(action: {
                    patientViewModel.actionFollowDoctor(doctorId: doctor.id)
                    patientViewModel.getDoctorsFollowers()
                }) {
                    Text("Unfollow".localized())
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 7)
                        .background(patientViewModel.doctorsIsFollow[doctor.id] == true ? Color.accentColor : Color.accentColor)
                        .cornerRadius(8)
                }
                .onAppear {
                    patientViewModel.doctorImage(from: pathImgDoctor, for: doctor.id)
                }
            }
        }
    }
}

enum folower : String {
    case AllDoctors  = "All Doctors"
    case AllFollowerDoctors  = "All Follower Doctors"
}

// MARK: - Preview
#Preview {
    SpecializationsDoctorsView(patientViewModel: PatientSettingViewModel())
        .environmentObject(AppState())
}
