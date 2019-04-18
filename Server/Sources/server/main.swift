//
//  main.swift
//  PerfectTemplate
//
//  Created by Cheng Sun on 4/16/19.
//  Copyright © 2019 EF. All rights reserved.
//

import PerfectHTTP
import PerfectHTTPServer
import PerfectLib
import Foundation

func handler(request: HTTPRequest, response: HTTPResponse) {
    
    var name: String?
    var pwd: String?
    
    // 获得当前的请求路径
    let path = request.path
    print("path =" + "\(path)")
    response.setHeader(.contentType, value: "application/json")

    switch path {
    case "/login" : do {
        if let item1 = request.param(name: "username") {
            name = item1
        }
        if let item2 = request.param(name: "pwd") {
            pwd = item2
        }
        
        if name == "Genie" && pwd == "123456" {
            let d: [String:Any] = ["token": "193725"]
            
            do {
                try response.setBody(json: d)
            } catch {
                //...
            }
            response.completed()
        }
    }
    case "/profile" : do {
        if let to = request.param(name: "token") {
            if to == "193725" {
                // right now
                // go get profile

                let d: [String:Any] = ["userage": "27", "sex": "man", "portrait" : "/Users/admin/Desktop/swift server/RUNING/Client/Server/home.jpg"]

                do {
                    try response.setBody(json: d)
                } catch {
                    //...
                }
            }
        }
        response.completed()
        }
    case "/photo" : do {
        if let path = request.param(name: "path") {
            
//            let docRoot = request.documentRoot
            do {
                let mrPebbles = File(path)
                let imageSize = mrPebbles.size
                let imageBytes = try mrPebbles.readSomeBytes(count: imageSize)
                
                response.setHeader(.contentType, value: MimeType.forExtension("jpg"))
                response.setHeader(.contentLength, value: "\(imageBytes.count)")
                response.setBody(bytes: imageBytes)
            } catch {
                response.status = .internalServerError
                response.setBody(string: "请求处理出现错误： \(error)")
            }
        }
        response.completed()
        }
    default:
        break
    }
}


var routes = Routes()
//routes.add(method: .get, uri: "/login", handler: handler)

let confData = [
    "servers": [ ["name" : "localhost",
                  "port" : 8080,
                  "routes" : [["method": "post", "uri": "/login", "handler": handler],
                              ["method": "post", "uri": "/profile", "handler": handler],
                              ["method": "get", "uri": "/photo", "handler": handler]]
        ]
    ]
]

do {
    try HTTPServer.launch(configurationData: confData)
} catch {
    fatalError("\(error)")
}
