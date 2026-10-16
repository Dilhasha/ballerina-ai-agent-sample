import ballerina/ai;
import ballerina/http;

configurable int port = 8090;

listener ai:Listener chatListener = new (port);

service /shoppingAgent on chatListener {
    resource function post chat(@http:Payload ai:ChatReqMessage request) returns ai:ChatRespMessage|error {
        string response = check shoppingAgent.run(request.message, request.sessionId);
        return {message: response};
    }
}
