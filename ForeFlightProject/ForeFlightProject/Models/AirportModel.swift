//
//  AirportModel.swift
//  ForeFlightProject
//
//  Created by Andy Lindberg on 5/13/22.
//

import Foundation



// MARK: - AirportModel
public struct AirportModel: Decodable {
    let report: Report?
}

// MARK: - Report
struct Report: Decodable {
    let conditions: Conditions?
    let forecast: ReportForecast?
    let windsAloft: ReportWindsAloft?
    let mos: MOS?
}

// MARK: - Conditions
struct Conditions: Decodable {
    let text, ident: String?
    let dateIssued: String?
    let lat, lon: Double?
    let elevationFt, tempC, dewpointC: Int?
    let pressureHg, pressureHpa: Double?
    let reportedAsHpa: Bool?
    let densityAltitudeFt, relativeHumidity: Int?
    let flightRules: String?
    let cloudLayers, cloudLayersV2: [CloudLayer]?
    let weather: [String]?
    let visibility: ConditionsVisibility?
    let wind: Wind?
    let remarks: Remarks?
}

// MARK: - CloudLayer
struct CloudLayer: Decodable {
    let coverage: String?
    let altitudeFt: Int?
    let ceiling: Bool?
    let type: String?
    let altitudeQualifier: Int?
}

enum Coverage: Decodable {
    case bkn
    case few
    case sct
    case skc
}

// MARK: - Remarks
struct Remarks: Decodable {
    let precipitationDiscriminator, humanObserver: Bool?
    let seaLevelPressure, temperature, dewpoint: Double?
    let visibility: WeatherBeginEndsClass?
    let weatherBeginEnds: WeatherBeginEndsClass?
}

// MARK: - WeatherBeginEndsClass
struct WeatherBeginEndsClass: Decodable {
}

// MARK: - ConditionsVisibility
struct ConditionsVisibility: Decodable {
    let distanceSm, prevailingVisSm: Int?
}

// MARK: - Wind
struct Wind: Decodable {
    let speedKts, direction, from: Double?
    let variable: Bool?
    let gustSpeedKts: Double?
}

// MARK: - ReportForecast
struct ReportForecast: Decodable {
    let text, ident: String?
    let dateIssued: String?
    let period: Period?
    let lat, lon: Double?
    let elevationFt: Int?
    let conditions: [WeatherCondition]?
}

// MARK: - WeatherCondition
struct WeatherCondition: Decodable {
    let text: String?
    let dateIssued: String?
    let lat, lon: Double?
    let elevationFt, relativeHumidity: Int?
    let flightRules: String?
    let cloudLayers, cloudLayersV2: [CloudLayer]?
    let weather: [String]?
    let visibility: AirportVisibility?
    let wind: Wind?
    let period: Period?
}

// MARK: - Period
struct Period: Decodable {
    let dateStart, dateEnd: String?
}

// MARK: - AirportVisibility
struct AirportVisibility: Decodable {
    let distanceSm, prevailingVisSm: Int?
    let distanceQualifier, prevailingVisDistanceQualifier: Int?
}

// MARK: - MOS
struct MOS: Decodable {
    let station: String?
    let issued: String?
    let period: Period?
    let latitude, longitude: Double?
    let forecast: MOSForecast?
}

// MARK: - MOSForecast
struct MOSForecast: Decodable {
    let text, ident: String?
    let dateIssued: String?
    let period: Period?
    let lat, lon: Double?
    let elevationFt: Int?
    let conditions: [AirportCondition]?
}

// MARK: - AirportCondition
struct AirportCondition: Decodable {
    let text: String?
    let tempMinC, tempMaxC, dewpointMinC, dewpointMaxC: Double?
    let flightRules: String?
    let cloudLayers, cloudLayersV2: [CloudLayer]?
    let weather: [String]?
    let visibility: SecondaryAirportVisibility?
    let wind: Wind?
    let period: Period?
}

// MARK: - SecondaryAirportVisibility
struct SecondaryAirportVisibility: Decodable {
    let distanceSm: Double?
    let distanceQualifier: Int?
}

// MARK: - ReportWindsAloft
struct ReportWindsAloft: Decodable {
    let lat, lon: Double?
    let dateIssued: String?
    let windsAloft: [WindsAloftElement]?
    let source: String?
}

// MARK: - WindsAloftElement
struct WindsAloftElement: Decodable {
    let validTime: String?
    let period: Period?
    let windTemps: [String: WindTemp]?
}

// MARK: - WindTemp
struct WindTemp: Decodable {
    let directionFromTrue, knots, celsius, altitude: Int?
    let isLightAndVariable, isGreaterThan199Knots, turbulence, icing: Bool?
}
