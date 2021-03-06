import ballerina/http;
import ballerina/swagger;
import ballerinax/kubernetes;

// Generate Docker image and Kubernetes deployment artifacts
// for that service to be started with kubectl apply -f
@kubernetes:Deployment {
    image: "demo/ballerina-demo",
    name: "ballerina-demo"
}

// Generate swagger with: ballerina swagger export demo.bal
@swagger:ServiceInfo {
    title: "Hello World Service",
    serviceVersion: "2.0.0",
    description: "Simple hello world service"
}

// Change the service context
@http:ServiceConfig {
    basePath: "/"
}

service<http:Service> hello bind {port: 9090} {
    // change the resource path and accepted verbs
    @http:ResourceConfig {
        path: "/",
        methods: ["GET"]
    }
    hi (endpoint caller, http:Request request) {
        http:Response res;
        res.setTextPayload("Hello World!\n");
        _ = caller->respond(res);
    }
}