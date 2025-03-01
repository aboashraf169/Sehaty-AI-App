//
//  AdviceView.swift
//  Sahaty
//
//  Created by mido mj on 12/17/24.
//

import  SwiftUI
struct AdviceView: View {
    var advice: AdviceModel // النصيحة التي سيتم عرضها
    var body: some View {
        HStack {
            // شريط جانبي ملون
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 5, height: 35)
                .foregroundStyle(.accent)
            
            VStack(alignment: .leading, spacing: 5) {
                // محتوى النصيحة
                Text(advice.advice)
                    .font(.headline)
                    .fontWeight(.regular)
                    .lineLimit(3)
                    .foregroundColor(.primary)
                
//                // وقت الإنشاء أو التحديث
//                Text("\(advice.updatedAt)")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
            }
            
            Spacer()

        }
        .padding(.horizontal)
        
    }
    
}
#Preview {
    AdviceView(advice: AdviceModel(id: 0, advice: "انا محمد اشرف المجايدة"))
}
