import SwiftUI

struct HeaderHomeSectionView: View {
    @ObservedObject var doctorProfileViewModel: DoctorProfileViewModel
    @AppStorage("appLanguage") private var appLanguage = "ar"
    var onProfileTap: () -> Void
    var onAddTap: (() -> Void)? = nil
    
    var body: some View {
        VStack{
        HStack(spacing: 16) {
            Button(action: onProfileTap) {
                if let img = doctorProfileViewModel.doctorProfileImage {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .padding(.top,10)
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.accent)
                        .clipShape(Circle())
                }

            }
            .buttonStyle(ScaleButtonStyle())
            
            
            Text(doctorProfileViewModel.doctor.name)
                .foregroundStyle(.primary)
                .font(.headline)
                .fontWeight(.medium)
            
            
            Spacer()
            
            if let onAddTap = onAddTap {
                Button(action: onAddTap) {
                    HStack {
                        Image(systemName: "text.badge.plus")
                            .font(.title3)
                            .foregroundStyle(.accent)
                        Text("new_article".localized())
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)

                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                }
                .buttonStyle(ScaleButtonStyle())
            }
            
        }
        .padding(.horizontal)
            Divider()
    }
        .direction(appLanguage)
        .environment(\.locale, .init(identifier: appLanguage))
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}

// MARK: - Preview
#Preview {
    HeaderHomeSectionView(
        doctorProfileViewModel: DoctorProfileViewModel(),
        onProfileTap: {
            print("Profile tapped")
        },
        onAddTap: {
            print("Add button tapped")
        }
    )
}

