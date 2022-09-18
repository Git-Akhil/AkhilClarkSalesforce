public class calloutclass {
    @future(callout = true)
    public static void makecallout(){
        httprequest request = new httprequest();
        string endpoint = 'http://yourHost/yourService';
        request.setEndpoint(endpoint);
        request.setmethod('get');
        httpresponse response = new http().send(request);

}
    
    
}