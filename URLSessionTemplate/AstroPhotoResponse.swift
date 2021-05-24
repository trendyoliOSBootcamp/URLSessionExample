//
//  AstroPhotoResponse.swift
//  URLSessionTemplate
//
//  Created by Unal Celik on 21.05.2021.
//

import Foundation

struct AstroPhotoResponse: Decodable {
    let date: String?
    let explanation: String?
    let hdurl: String?
    let title: String?
}
