import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import Alamofire

// Create HTTP server.
let server = HTTPServer()

// Register your own routes and handlers
var routes = Routes()
routes.add(method: .get, uri: "/", handler: { request, response in
        response.setHeader(.contentType, value: "text/html")
        response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
        response.completed()
    }
)

routes.add(method: .get, uri: "/get_articles", handler: { request, response in
    
    //Fetch all articles from table article
    Alamofire.request(
        "http://data.default/v1/query",
        method: HTTPMethod.post,
        parameters: [
            "type": "select",
            "args": [
                "table": "article",
                "columns": [
                    "*"
                ]
            ]
        ],
        encoding: JSONEncoding.default,
        headers: nil)
        .validate()
        .responseJSON { (alamofireResponse) in
            switch alamofireResponse.result {
            case .success(let value):
                if let responseArray = value as? [[String: Any]] {
                    do {
                        try response.setBody(json: responseArray)
                    } catch {
                        response.setBody(string: "Unable to parse JSON response")
                    }
                    
                }
                break
            case .failure(let error):
                response.setBody(string: error.localizedDescription)
                break
            }
            response.setHeader(.contentType, value: "application/json")
            response.completed()
    }
    
})

// Add the routes to the server.
server.addRoutes(routes)

// Set a listen port of 8181
server.serverPort = 8080

do {
    // Launch the HTTP server.
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
