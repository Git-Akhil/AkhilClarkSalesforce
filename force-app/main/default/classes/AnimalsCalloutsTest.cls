@isTest
private class AnimalsCalloutsTest {
    /*@isTest static void testGetcallout(){
        staticResourceCalloutMock mock = new staticResourceCallOutMock();
        mock.setStaticResource('GetAnimalResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type','application/json;charset=UTF-8');
        test.setMock(HttpcalloutMock.class, mock);
        
        httpResponse result = AnimalsCallouts.makeGetcallout();
        system.assertNotEquals(null, result, 'The callout returned a null response.');
        system.assertEquals(200, result.getStatusCode(), 'The status code is not 200.');
        system.assertEquals('application/json;charset=UTF-8', result.getHeader('Content-Type'), 'The content type value is not expected.');
        
        map<string,object> results = (map<string,object>) JSON.deserializeUntyped(result.getBody());
        list<object> animals = (list<Object>) results.get('animals');
        system.assertEquals(3, animals.size(), 'The array should only contain 3 items.');
   }*/
    
    @istest static void testpostcallout(){
        test.setMock(Httpcalloutmock.class, new AnimalsHttpCalloutMock());
        HttpResponse response = AnimalsCallouts.makePostcallout();
        
        string contentType = response.getHeader('Content-Type');
        system.assert(contentType == 'application/json');
        string actualValue = response.getBody();
        string expectedValue = '{"animals": ["majestic badger", "fluffy bunny", "scary bear", "chicken", "mighty moose"]}';
        system.assertequals(actualValue , expectedValue);
        system.assertEquals(200, response.getStatusCode());
    }
}