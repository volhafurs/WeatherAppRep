//
//  SearchResponse.swift
//  WeatherApp
//
//  Created by Volha Furs on 17.05.22.
//

import Foundation

struct SearchResponse: Decodable {
    var name: String
    var country: String
    var state: String?
    var lat: Float
    var lon: Float
}
