//
//  ForecastViewModel.swift
//  ForeFlightProject
//
//  Created by Andy Lindberg on 5/15/22.
//

import Foundation

struct ForecastViewModel {
    let title: String
    let sections: [ForecastSectionModel]
    
    
    init(model: ReportForecast) {
        let textCell: CellModel = .text(title: "Text", value: model.text ?? StringConstants.noDataString)
        let identCell: CellModel = .text(title: "Ident", value: model.ident ?? StringConstants.noDataString)
        let dateCell: CellModel = .text(title: "Date Issued", value: model.dateIssued ?? StringConstants.noDataString)
        let dateStart:CellModel = .text(title: "Date Start", value: model.period?.dateStart ?? StringConstants.noDataString)
        let dateEnd:CellModel = .text(title: "Date End", value: model.period?.dateEnd ?? StringConstants.noDataString)
        let elevationCell: CellModel = .text(title: "Elevation(Ft)", value: String(model.elevationFt ?? 9999))
        let generalInformationSection: ForecastSectionModel = .init(title: "General Information", cells: [textCell, identCell, dateCell, dateStart, dateEnd, elevationCell])
        
        let latCell: CellModel = .text(title: "Lat", value: String(model.lat ?? 9999))
        let lonCell: CellModel = .text(title: "Lat", value: String(model.lon ?? 9999))
        let coordinateSection: ForecastSectionModel = .init(title: "Coordinates", cells: [latCell, lonCell])

        var conditionSections: [ForecastSectionModel] = []
        if let conditions = model.conditions {
            var cloudSections: [ForecastSectionModel] = []
            for i in 0..<conditions.count {
                let textCell: CellModel = .text(title: "Text", value: conditions[i].text ?? StringConstants.noDataString)
                let dateIssuedCell: CellModel = .text(title: "Date Issued", value: conditions[i].dateIssued ?? StringConstants.noDataString)
                let latCell: CellModel = .text(title: "Lat", value: String(conditions[i].lat ?? 9999))
                let lonCell: CellModel = .text(title: "Lon", value: String(conditions[i].lon ?? 9999))
                let elevationCell: CellModel = .text(title: "Elevation(Ft)", value: String(conditions[i].elevationFt ?? 9999))
                let humidityCell: CellModel = .text(title: "Relative Humidity", value: String(conditions[i].relativeHumidity ?? 9999) + "%")
                let flightRulesCell: CellModel = .text(title: "Flight Rules", value: conditions[i].flightRules ?? StringConstants.noDataString)
                
                let generalInformationSection: ForecastSectionModel = .init(title: "General Information -" + String(i + 1), cells: [textCell, dateIssuedCell, latCell, lonCell, elevationCell, humidityCell, flightRulesCell])

                conditionSections.append(generalInformationSection)
                
                let distanceSmCell: CellModel = .text(title: "Distance(Sm)", value: String(conditions[i].visibility?.distanceSm ?? 9999))
                let distanceQualifierCell: CellModel = .text(title: "Distance(Sm)", value: String(conditions[i].visibility?.distanceQualifier ?? 9999))
                let prevailingVisSmCell: CellModel = .text(title: "Prevailing Vis Sm", value: String(conditions[i].visibility?.prevailingVisSm ?? 9999))
                let prevailingVisDistanceQualifierCell: CellModel = .text(title: "Prevailing Vis Distance Qualifier", value: String(conditions[i].visibility?.prevailingVisDistanceQualifier ?? 9999))

                let visibilitySection: ForecastSectionModel = .init(title: "Visibility -" + String(i + 1), cells: [distanceSmCell, distanceQualifierCell, prevailingVisSmCell, prevailingVisDistanceQualifierCell])
                
                conditionSections.append(visibilitySection)
                
                let windSpeedCell: CellModel = .text(title: "Wind Speed(Kts)", value: String(conditions[i].wind?.speedKts ?? 9999))
                let windDirectionCell: CellModel = .text(title: "Wind Direction", value: String(conditions[i].wind?.direction ?? 9999))
                let windFrom: CellModel = .text(title: "Wind From", value: String(conditions[i].wind?.from ?? 9999))
                let windVariable: CellModel = .text(title: "Variable", value: String(conditions[i].wind?.variable ?? false))
                let windSection: ForecastSectionModel = .init(title: "Wind -" + String(i + 1), cells: [windSpeedCell, windDirectionCell, windFrom, windVariable])
                
                conditionSections.append(windSection)

                if let cloudLayers = conditions[i].cloudLayers {
                    for j in 0..<cloudLayers.count {
                        let coverageCell: CellModel = .text(title: "Coverage", value: cloudLayers[j].coverage ?? StringConstants.noDataString)
                        let typeCell: CellModel = .text(title: "Type", value: cloudLayers[j].type ?? StringConstants.noDataString)
                        let altitudeCell: CellModel = .text(title: "Altitude(Ft)", value: String(cloudLayers[j].altitudeFt ?? 9999))
                        let ceilingCell: CellModel = .text(title: "Ceiling", value: String(cloudLayers[j].ceiling ?? false))
                        
                        let cloudLayerSection: ForecastSectionModel = .init(title: "Cloud Layers -" + String(j + 1), cells: [coverageCell, typeCell, altitudeCell, ceilingCell])
                        cloudSections.append(cloudLayerSection)
                    }
                }
                
                if let cloudLayers = conditions[i].cloudLayersV2 {
                    for j in 0..<cloudLayers.count {
                        let coverageCell: CellModel = .text(title: "Coverage", value: cloudLayers[j].coverage ?? StringConstants.noDataString)
                        let typeCell: CellModel = .text(title: "Type", value: cloudLayers[j].type ?? StringConstants.noDataString)
                        let altitudeCell: CellModel = .text(title: "Altitude(Ft)", value: String(cloudLayers[j].altitudeFt ?? 9999))
                        let ceilingCell: CellModel = .text(title: "Ceiling", value: String(cloudLayers[j].ceiling ?? false))
                        
                        let cloudLayerSection: ForecastSectionModel = .init(title: "Cloud LayersV2 -" + String(j + 1), cells: [coverageCell, typeCell, altitudeCell, ceilingCell])
                        cloudSections.append(cloudLayerSection)
                    }
                }
                
                if let weather = conditions[i].weather {
                    for j in 0..<weather.count {
                        let weatherCell: CellModel = .text(title: "Conditions", value: weather[j])
                        
                        let weatherSection: ForecastSectionModel = .init(title: "Weather -" + String(j + 1), cells: [weatherCell])
                        cloudSections.append(weatherSection)
                    }
                }
                
                
            }
            conditionSections += cloudSections
        }

        self.title = "Forecast"
        self.sections = [generalInformationSection, coordinateSection] + conditionSections
        
    }
}

extension ForecastViewModel {
    struct ForecastSectionModel {
        let title: String?
        let cells: [CellModel]
    }
}

extension ForecastViewModel {
    enum CellModel {
        // You can extend this CellModel enum to have any number of different types that you want to be displayed in different ways
        case text(title: String, value: String)
        case map(latitude: Double, longitude: Double)
    }
}
