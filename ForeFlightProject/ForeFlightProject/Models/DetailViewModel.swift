//
//  DetailViewModel.swift
//  ForeFlightProject
//
//  Created by Andy Lindberg on 5/15/22.
//

import Foundation

struct DetailViewModel {
    let title: String
    let sections: [SectionModel]
    
    
    init(model: Conditions) {
        let textCell: CellModel = .text(title: "Text", value: model.text ?? StringConstants.noDataString)
        let identCell: CellModel = .text(title: "Ident", value: model.ident ?? StringConstants.noDataString)
        let dateCell: CellModel = .text(title: "Date Issued", value: model.dateIssued ?? StringConstants.noDataString)
        let generalInformationSection: SectionModel = .init(title: "General Information", cells: [textCell, identCell, dateCell])
        
        let latCell: CellModel = .text(title: "Lat", value: String(model.lat ?? 9999))
        let lonCell: CellModel = .text(title: "Lat", value: String(model.lon ?? 9999))
        let coordinateSection: SectionModel = .init(title: "Coordinates", cells: [latCell, lonCell])

        
        let pressureHgCell: CellModel = .text(title: "Pressure(Hg)", value: String(model.pressureHg ?? 9999))
        let pressureHpaCell: CellModel = .text(title: "Pressure(Hpa)", value: String(model.pressureHpa ?? 9999))
        let reportedAsHpaCell: CellModel = .text(title: "Reported As Hpa", value: String(model.reportedAsHpa ?? false))
        let pressureSection: SectionModel = .init(title: "Pressure", cells: [pressureHgCell, pressureHpaCell, reportedAsHpaCell])
        
        let elevationCell: CellModel = .text(title: "Elevation(Ft)", value: String(model.elevationFt ?? 9999))
        let tempCell: CellModel = .text(title: "Temperature(ºC)", value: String(model.tempC ?? 9999))
        let dewpointCell: CellModel = .text(title: "Dewpoint(ºC)", value: String(model.dewpointC ?? 9999))
        let densityCell: CellModel = .text(title: "Density Altitude(Ft)", value: String(model.densityAltitudeFt ?? 9999))
        let humidityCell: CellModel = .text(title: "Relative Humidity", value: String(model.densityAltitudeFt ?? 9999) + "%")
        let flightRulesCell: CellModel = .text(title: "Flight Rules", value: model.flightRules ?? StringConstants.noDataString)
        let miscSection: SectionModel = .init(title: "Miscellaneous", cells: [elevationCell, tempCell, dewpointCell, densityCell, humidityCell, flightRulesCell])
        
        var cloudSections: [SectionModel] = []
        if let cloudLayers = model.cloudLayers {
            for i in 0..<cloudLayers.count {
                let coverageCell: CellModel = .text(title: "Coverage", value: cloudLayers[i].coverage ?? StringConstants.noDataString)
                let altitudeCell: CellModel = .text(title: "Altitude(Ft)", value: String(cloudLayers[i].altitudeFt ?? 9999))
                let ceilingCell: CellModel = .text(title: "Ceiling", value: String(cloudLayers[i].ceiling ?? false))
                
                let cloudLayerSection: SectionModel = .init(title: "Cloud Layers -" + String(i + 1), cells: [coverageCell, altitudeCell, ceilingCell])
                cloudSections.append(cloudLayerSection)
            }
        }
        
        if let cloudLayersV2 = model.cloudLayersV2 {
            for i in 0..<cloudLayersV2.count {
                let coverageCell: CellModel = .text(title: "Coverage", value: cloudLayersV2[i].coverage ?? StringConstants.noDataString)
                let altitudeCell: CellModel = .text(title: "Altitude(Ft)", value: String(cloudLayersV2[i].altitudeFt ?? 9999))
                let ceilingCell: CellModel = .text(title: "Ceiling", value: String(cloudLayersV2[i].ceiling ?? false))
                
                let cloudLayerSection: SectionModel = .init(title: "Cloud LayersV2 -" + String(i + 1), cells: [coverageCell, altitudeCell, ceilingCell])
                cloudSections.append(cloudLayerSection)
            }
        }
        
        if let weather = model.weather {
            for i in 0..<weather.count {
                let weatherCell: CellModel = .text(title: "Conditions", value: weather[i])
                
                let weatherSection: SectionModel = .init(title: "Weather -" + String(i + 1), cells: [weatherCell])
                cloudSections.append(weatherSection)
            }
        }
        
        let distanceSmCell: CellModel = .text(title: "Distance(Sm)", value: String(model.visibility?.distanceSm ?? 9999))
        let prevailingVisSmCell: CellModel = .text(title: "Prevailing Vis Sm", value: String(model.visibility?.prevailingVisSm ?? 9999))
        let visibilitySection: SectionModel = .init(title: "Visibility", cells: [distanceSmCell, prevailingVisSmCell])
        
        let windSpeedCell: CellModel = .text(title: "Wind Speed(Kts)", value: String(model.wind?.speedKts ?? 9999))
        let windDirectionCell: CellModel = .text(title: "Wind Direction", value: String(model.wind?.direction ?? 9999))
        let windFrom: CellModel = .text(title: "Wind From", value: String(model.wind?.from ?? 9999))
        let windVariable: CellModel = .text(title: "Variable", value: String(model.wind?.variable ?? false))
        let windSection: SectionModel = .init(title: "Wind", cells: [windSpeedCell, windDirectionCell, windFrom, windVariable])

        self.title = "Conditions"
        self.sections = [generalInformationSection, coordinateSection, pressureSection, miscSection, visibilitySection, windSection] + cloudSections
        
    }
}

extension DetailViewModel {
    struct SectionModel {
        let title: String?
        let cells: [CellModel]
    }
}

extension DetailViewModel {
    enum CellModel {
        // You can extend this CellModel enum to have any number of different types that you want to be displayed in different ways
        case text(title: String, value: String)
        case map(latitude: Double, longitude: Double)
    }
}
