//
//  Session.swift
//  Transmission Remote
//
//  Created by 👽 on 4/29/20.
//  Copyright © 2020 chead. All rights reserved.
//

import Foundation

public final class Client {
    public enum ClientError: Error {
        case badTag
        case badIdentifier
        case authenticationFailed
        case unknown
    }

    public let host: String
    public let port: String
    public var identifier: String?
    public let credentials: Credentials?

    let urlSession: URLSession

    public init(host: String, port: String, credentials: Credentials?, urlSession: URLSession) {
        self.host = host
        self.port = port
        self.credentials = credentials
        self.urlSession = urlSession
    }

    public convenience init(host: String, port: String, credentials: Credentials?) {
        let urlSession = URLSession(configuration: .default)

        self.init(host: host, port: port, credentials: credentials, urlSession: urlSession)
    }

    public func make<Arguments: Encodable, Model: Decodable>(request: Request<Arguments, Model>, completion: @escaping (Result<Response<Model>, Error>) -> ()) {
        self.make(request: request, retry: true, completion: completion)
    }

    public func make<Arguments: Encodable, Model: Decodable>(request: Request<Arguments, Model>, retry: Bool, completion: @escaping (Result<Response<Model>, Error>) -> ()) {

        guard
            let hostURL = URL(string: "http://\(host):\(port)/transmission/rpc")
        else {
            completion(.failure(ClientError.unknown)) //FIXME: Specialize error for bad URL

            return
        }

        var urlRequest = URLRequest(url: hostURL)

        urlRequest.httpMethod = "POST"

        urlRequest.setValue("application/json-rpc", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        urlRequest.setValue(self.identifier, forHTTPHeaderField: "X-Transmission-Session-Id")

        if let credentials = self.credentials {
            let credentialsData = String(format: "%@:%@", credentials.username, credentials.password).data(using: .utf8)?.base64EncodedString()

            urlRequest.setValue("Basic \(credentialsData ?? "")", forHTTPHeaderField: "Authorization")
        }

        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            completion(.failure(error))
        }

        self.urlSession.dataTask(with: urlRequest) { (data, response, error) in
            switch(data, response, error) {
            case (let data?, let httpURLResponse as HTTPURLResponse, nil):
                switch httpURLResponse.statusCode {
                case 409:
                    guard
                        let identifier = httpURLResponse.allHeaderFields["X-Transmission-Session-Id"] as? String
                    else {
                        completion(.failure(ClientError.badIdentifier))

                        break
                    }

                    self.identifier = identifier

                    if retry == true {
                        self.make(request: request, retry: false, completion: completion)
                    } else {
                        completion(.failure(ClientError.badIdentifier))
                    }

                case 200:
                    do {
                        let response = try JSONDecoder().decode(Response<Model>.self, from: data)

                        if response.tag == request.tag {
                            completion(.success(response))
                        } else {
                            completion(.failure(ClientError.badTag))
                        }
                    } catch(let error) {
                        completion(.failure(error))
                    }

                case 401:
                    break

                default:
                    completion(.failure(ClientError.unknown))
                }

            case (_, _, let error):
                completion(.failure(error!))
            }
        }.resume()
    }
}
