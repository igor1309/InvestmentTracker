//
//  sample data projects.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 04.07.2020.
//

import Foundation
import InvestmentDataModel

extension Project {
    static let projects: [Project] = [saperavi, vaiMe]
    
    static let (saperavi, vaiMe): (Project, Project) = {
        let progressOOO = Entity("Прогресс, ООО")
        let kitProgressOOO = Entity("Кит-Прогресс, ООО")
        let igor = Entity("IM")
        
        let calendar = Calendar.autoupdatingCurrent
        
        let date1 = calendar.date(from: DateComponents(year: 2019, month: 12, day: 2))!
        let payment1 = Payment(
            date: date1,
            amount: 6_000_000,
            currency: .rub,
            sender: igor,
            recipient: progressOOO,
            note: "Транш по договору займа"
        )
        
        let date2 = calendar.date(from: DateComponents(year: 2019, month: 12, day: 13))!
        let payment2 = Payment(
            date: date2,
            amount: 4_000_000,
            currency: .rub,
            sender: igor,
            recipient: progressOOO,
            note: "Транш по договору займа"
        )
        
        let date3 = calendar.date(from: DateComponents(year: 2019, month: 12, day: 20))!
        let payment3 = Payment(
            date: date3,
            amount: 5_000_000,
            currency: .rub,
            sender: igor,
            recipient: progressOOO,
            note: "Транш по договору займа"
        )
        
        let date4 = calendar.date(from: DateComponents(year: 2020, month: 1, day:  14))!
        let payment4 = Payment(
            date: date4,
            amount: 5_000_000,
            currency: .rub,
            sender: igor,
            recipient: progressOOO,
            note: "Транш по договору займа"
        )
        
        let date5 = calendar.date(from: DateComponents(year: 2020, month: 2, day: 4))!
        let payment5 = Payment(
            date: date5,
            amount: 5_000_000,
            currency: .rub,
            sender: igor,
            recipient: progressOOO,
            note: "Транш по договору займа"
        )
        
        let date6 = calendar.date(from: DateComponents(year: 2020, month: 4, day: 16))!
        let payment6 = Payment(
            date: date6,
            amount: 5_000_000,
            currency: .rub,
            sender: igor,
            recipient: progressOOO,
            note: "Транш по договору займа"
        )
        
        let saperavi = Project(
            name: "Саперави Аминьевка",
            note: "ТЦ Квартал W (Ташир)",
            entities: [progressOOO],
            payments: [payment1, payment2, payment3, payment4, payment5, payment6]
        )
        
        let date7 = calendar.date(from: DateComponents(year: 2020, month: 2, day: 18))!
        let payment7 = Payment(
            date: date7,
            amount: 9_000_000,
            currency: .rub,
            sender: igor,
            recipient: kitProgressOOO,
            note: "Транш по договору займа"
        )
        
        let date8 = calendar.date(from: DateComponents(year: 2020, month: 5, day: 20))!
        let payment8 = Payment(
            date: date8,
            amount: 2_000_000,
            currency: .rub,
            sender: igor,
            recipient: kitProgressOOO,
            note: "Транш по договору займа"
        )
        
        let date9 = calendar.date(from: DateComponents(year: 2020, month: 6, day: 9))!
        let payment9 = Payment(
            date: date9,
            amount: 2_000_000,
            currency: .rub,
            sender: igor,
            recipient: kitProgressOOO,
            note: "Транш по договору займа"
        )
        
        let vaiMe = Project(
            name: "ВайМэ! Щелково",
            note: "МФК Щелковский, ГК Киевская площадь",
            entities: [kitProgressOOO],
            payments: [payment7, payment8, payment9]
        )
        
        return (saperavi, vaiMe)
    }()
}

