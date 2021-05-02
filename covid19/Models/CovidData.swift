//
//  CovidData.swift
//  covid19
//
//  Created by Jeevan on 29/04/21.
//

import Foundation

struct CovidData: Codable {
    let casesTimeSeries: [CasesTimeSery]
    let statewise: [Statewise]
    let tested: [Tested]

    enum CodingKeys: String, CodingKey {
        case casesTimeSeries = "cases_time_series"
        case statewise, tested
    }
}

// MARK: - CasesTimeSery
struct CasesTimeSery: Codable {
    let dailyconfirmed, dailydeceased, dailyrecovered, date: String?
    let dateymd, totalconfirmed, totaldeceased, totalrecovered: String?
}

// MARK: - Statewise
struct Statewise: Codable {
    let active, confirmed, deaths, deltaconfirmed: String?
    let deltadeaths, deltarecovered, lastupdatedtime, migratedother: String?
    let recovered, state, statecode, statenotes: String?
}

// MARK: - Tested
struct Tested: Codable {
    let aefi, dailyrtpcrsamplescollectedicmrapplication, firstdoseadministered, frontlineworkersvaccinated1Stdose: String?
    let frontlineworkersvaccinated2Nddose, healthcareworkersvaccinated1Stdose, healthcareworkersvaccinated2Nddose, over45Years1Stdose: String?
    let over45Years2Nddose, over60Years1Stdose, over60Years2Nddose, positivecasesfromsamplesreported: String?
    let registrationflwhcw, registrationonline, registrationonspot, samplereportedtoday: String?
    let seconddoseadministered: String?
    let source: String?
    let source2, source3: String?
    let source4: String?
    let testedasof, testsconductedbyprivatelabs, to60YearswithcoMorbidities1Stdose, to60YearswithcoMorbidities2Nddose: String?
    let totaldosesadministered, totalindividualsregistered, totalindividualstested, totalindividualsvaccinated: String?
    let totalpositivecases, totalrtpcrsamplescollectedicmrapplication, totalsamplestested, totalsessionsconducted: String?
    let updatetimestamp: String?

    enum CodingKeys: String, CodingKey {
        case aefi, dailyrtpcrsamplescollectedicmrapplication, firstdoseadministered
        case frontlineworkersvaccinated1Stdose = "frontlineworkersvaccinated1stdose"
        case frontlineworkersvaccinated2Nddose = "frontlineworkersvaccinated2nddose"
        case healthcareworkersvaccinated1Stdose = "healthcareworkersvaccinated1stdose"
        case healthcareworkersvaccinated2Nddose = "healthcareworkersvaccinated2nddose"
        case over45Years1Stdose = "over45years1stdose"
        case over45Years2Nddose = "over45years2nddose"
        case over60Years1Stdose = "over60years1stdose"
        case over60Years2Nddose = "over60years2nddose"
        case positivecasesfromsamplesreported, registrationflwhcw, registrationonline, registrationonspot, samplereportedtoday, seconddoseadministered, source, source2, source3, source4, testedasof, testsconductedbyprivatelabs
        case to60YearswithcoMorbidities1Stdose = "to60yearswithco-morbidities1stdose"
        case to60YearswithcoMorbidities2Nddose = "to60yearswithco-morbidities2nddose"
        case totaldosesadministered, totalindividualsregistered, totalindividualstested, totalindividualsvaccinated, totalpositivecases, totalrtpcrsamplescollectedicmrapplication, totalsamplestested, totalsessionsconducted, updatetimestamp
    }
}
