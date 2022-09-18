public class AnimalsCallouts {
    public static HttpResponse makeGetcallout(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> animals = (List<Object>) results.get('animals');
            System.debug('Received the following animals:');
            for (Object animal: animals) {
                System.debug(animal);
            }
        }
        return response;
    }
    
    public static HttpResponse makePostcallout(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint('https://th-apex-http-callout.herokuapp.com/animals');
        request.setMethod('POST');
        request.setheader('Content-Type','application/json;charset=UTF-8');
        request.setbody('{"name":"mighty moose"}');
        httpResponse response = http.send(request);
        if(response.getstatuscode() != 201){
            system.debug('the status code returned was not expected: '+ response.getstatuscode() + ' '+ response.getstatus());
        }
        else{
            system.debug(response.getbody());
        }
        return response;
    }
}