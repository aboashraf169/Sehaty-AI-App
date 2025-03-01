//
//  OnboardingView.swift
//  Sahaty
//
//  Created by mido mj on 2/22/25.
//


import SwiftUI

struct OnboardingView: View {
    @State private var currentStep = 0
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    let onboardingSteps: [OnboardingStep] = [
        OnboardingStep(image: "onboarding1", title: "صحتي", description:
                        "تطبيقك الصحي المدعوم بالذكاء الاصطناعي لمساعدتك على تحسين صحتك."),
        OnboardingStep(image: "onboarding1", title: "استشارات طبية سريعة", description: "احصل على نصائح طبية موثوقة من أطباء متخصصين مباشرة."),
        OnboardingStep(image: "onboarding2", title: "جاهز للبدء؟", description: "انضم إلينا وابدأ رحلة صحية أفضل الآن!")
    ]


    var body: some View {
        VStack {
            TabView(selection: $currentStep) {
                ForEach(0..<onboardingSteps.count, id: \.self) { index in
                    VStack(spacing: 20) {
                        
                        Image(onboardingSteps[index].image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)
                        
                        Text(onboardingSteps[index].title)
                            .font(.largeTitle)
                            .bold()
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.accentColor)
                            .padding(.top)

                        Text(onboardingSteps[index].description)
                            .font(.body)
                            .frame(maxWidth: 300)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .foregroundStyle(Color.accentColor)
                    

                        if index == onboardingSteps.count - 1 {
                            Button(action: {
                                hasSeenOnboarding = true
                            }) {
                                Text("ابدأ")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(width: 35, height: 35)
                                    .padding()
                                    .background(Color.accentColor)
                                    .cornerRadius(10)
                                    .clipShape(Circle())
                            }
                            .padding(.horizontal, 40)
                            .padding(.vertical, 40)
                        } else {
                            Button(action: {
                                currentStep += 1
                            }) {
                                Image(systemName: "arrow.right")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(width: 35, height: 35)
                                    .padding()
                                    .background(Color.accentColor)
                                    .cornerRadius(10)
                                    .clipShape(Circle())
                            }
                            .padding(.horizontal, 40)
                            .padding(.vertical, 40)

                        }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        }
    }
}

#Preview {
    OnboardingView()
}
