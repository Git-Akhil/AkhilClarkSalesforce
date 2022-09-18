@istest
global class AnimalLocatorMock implements Httpcalloutmock{
    global HTTPResponse respond(HTTPRequest request){
        HTTPResponse response = new HTTPResponse();
        response.setHeader('Content-Type',  'application/json');
        response.setBody('{"animal":{"id":1,"name":"trailhead","eats":"Chickem food","says":"Cluck cluck"}}');
        response.setStatusCode(200);
        return response;
    } 
}