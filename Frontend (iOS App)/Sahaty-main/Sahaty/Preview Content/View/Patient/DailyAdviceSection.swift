//
//  DailyAdviceSection.swift
//  Sahaty
//
//  Created by mido mj on 2/16/25.
//
import SwiftUI

   // MARK: - Daily Advice Section

    struct DailyAdviceSection: View {
        @ObservedObject var adviceViewModel: AdviceViewModel
        @State private var currentIndex = 0 // مؤشر النصيحة الحالية
        
        var body: some View {
            Group {
                if !adviceViewModel.userAdvices.isEmpty {
                    TabView(selection: $currentIndex) {
                        ForEach(Array(adviceViewModel.userAdvices.enumerated()), id: \.element.id) { index, advice in
                            adviceCard(advice)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .frame(height: 100)
                    .onAppear {
                        startAutoScroll()
                    }
                } else {
                    emptyAdviceView
                }
            }
        }
    }
// ✅ **تصميم بطاقة النصيحة**
private extension DailyAdviceSection {
    func adviceCard(_ advice: AdviceModel) -> some View {
            HStack(spacing: 10) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.accentColor)
                
                Text(advice.advice)
                    .font(.callout)
                    .foregroundColor(.primary)
                    .lineLimit(2)

                Spacer()
            }
            .padding()
            .padding(.vertical, 10)
            .background(Color(.systemGray6))
            .shadow(color: .gray.opacity(0.1), radius: 3, x: 0, y: 1)
    }

    // ✅ **عرض عند عدم وجود نصائح**
    var emptyAdviceView: some View {
        HStack {
            Text("no_advices".localized())
                .fontWeight(.medium)
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

// ✅ **إضافة التمرير التلقائي كل 30 ثانية**
private extension DailyAdviceSection {
    func startAutoScroll() {
        Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % adviceViewModel.userAdvices.count
            }
        }
    }
}

