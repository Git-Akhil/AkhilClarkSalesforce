public class AnimalLocator
{
    
    public static String getAnimalNameById(Integer id)
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        system.debug('====== id ===== '+id);
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+id);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        system.debug('******response '+response.getStatusCode());
        system.debug('******response '+response.getBody());
        string returnStr = '';
        if (response.getStatusCode() == 200) 
        {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<string, Object> animals = (Map<String, Object>) results.get('animal');
             system.debug('******animals******* '+animals);
            returnStr = string.valueof(animals.get('name'));
            system.debug('******returnStr******* '+returnStr);
        }
        return returnStr;
    }
    
}