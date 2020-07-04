//
//  sample data projects.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 04.07.2020.
//

import Foundation
import InvestmentDataModel

extension Entity {
    static let progressOOO = Entity("Прогресс, ООО")
    static let kitProgressOOO = Entity("Кит-Прогресс, ООО")
    static let igor = Entity("IM")
}

extension Project {
    static let projects: [Project] = [saperavi, vaiMe]
    
    static let saperavi: Project = {
        let calendar = Calendar.autoupdatingCurrent
        
        let date1 = calendar.date(from: DateComponents(year: 2019, month: 12, day: 2))!
        let payment1 = Payment(
            date: date1,
            amount: 6_000_000,
            currency: .rub,
            sender: Entity.igor,
            recipient: Entity.progressOOO,
            note: "Транш по договору займа"
        )
        
        let date2 = calendar.date(from: DateComponents(year: 2019, month: 12, day: 13))!
        let payment2 = Payment(
            date: date2,
            amount: 4_000_000,
            currency: .rub,
            sender: Entity.igor,
            recipient: Entity.progressOOO,
            note: "Транш по договору займа"
        )
        
        let date3 = calendar.date(from: DateComponents(year: 2019, month: 12, day: 20))!
        let payment3 = Payment(
            date: date3,
            amount: 5_000_000,
            currency: .rub,
            sender: Entity.igor,
            recipient: Entity.progressOOO,
            note: "Транш по договору займа"
        )
        
        let date4 = calendar.date(from: DateComponents(year: 2020, month: 1, day:  14))!
        let payment4 = Payment(
            date: date4,
            amount: 5_000_000,
            currency: .rub,
            sender: Entity.igor,
            recipient: Entity.progressOOO,
            note: "Транш по договору займа"
        )
        
        let date5 = calendar.date(from: DateComponents(year: 2020, month: 2, day: 4))!
        let payment5 = Payment(
            date: date5,
            amount: 5_000_000,
            currency: .rub,
            sender: Entity.igor,
            recipient: Entity.progressOOO,
            note: "Транш по договору займа"
        )
        
        let date6 = calendar.date(from: DateComponents(year: 2020, month: 4, day: 16))!
        let payment6 = Payment(
            date: date6,
            amount: 5_000_000,
            currency: .rub,
            sender: Entity.igor,
            recipient: Entity.progressOOO,
            note: "Транш по договору займа"
        )
        
        return Project(
            name: "Саперави Аминьевка",
            note: "ТЦ Квартал W (Ташир)",
            entities: [Entity.progressOOO],
            payments: [payment1, payment2, payment3, payment4, payment5, payment6]
        )
    }()
    
    static let vaiMe: Project = {
        let calendar = Calendar.autoupdatingCurrent
        
        let date1 = calendar.date(from: DateComponents(year: 2020, month: 2, day: 18))!
        let payment1 = Payment(
            date: date1,
            amount: 9_000_000,
            currency: .rub,
            sender: Entity.igor,
            recipient: Entity.kitProgressOOO,
            note: "Транш по договору займа"
        )
        
        let date2 = calendar.date(from: DateComponents(year: 2020, month: 5, day: 20))!
        let payment2 = Payment(
            date: date2,
            amount: 2_000_000,
            currency: .rub,
            sender: Entity.igor,
            recipient: Entity.kitProgressOOO,
            note: "Транш по договору займа"
        )
        
        let date3 = calendar.date(from: DateComponents(year: 2020, month: 6, day: 9))!
        let payment3 = Payment(
            date: date3,
            amount: 2_000_000,
            currency: .rub,
            sender: Entity.igor,
            recipient: Entity.kitProgressOOO,
            note: "Транш по договору займа"
        )
        
        let date4 = calendar.date(from: DateComponents(year: 2020, month: 7, day: 1))!
        let payment4 = Payment(date: date4, amount: 500_000, currency: .rub, sender: Entity.kitProgressOOO, recipient: Entity.igor, note: "ВОЗВРАТНЫЙ ПЛАТЕЖ ДЛЯ ТЕСТИРОВАНИЯ")
        
        return Project(
            name: "ВайМэ! Щелково",
            note: "МФК Щелковский, ГК Киевская площадь",
            entities: [Entity.kitProgressOOO],
            payments: [payment1, payment2, payment3, payment4]
        )
    }()
}

