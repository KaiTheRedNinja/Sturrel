//
//  QuizInfoView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 25/10/23.
//

import SwiftUI

struct QuizInfoView: View {
    @ObservedObject var quizManager: QuizManager

    var body: some View {
        HStack {
            ForEach(QuizStat.allCases) { stat in
                if quizManager.statsToShow.contains(stat) {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(stat.color)
                        .overlay {
                            VStack {
                                Text(stat.rawValue)
                                Text("\(quizManager[stat])")
                                    .font(.largeTitle)
                                    .bold()
                            }
                        }
                }
            }
        }
        .frame(maxHeight: 70)
    }
}
