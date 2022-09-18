public class ParkLocator {
    public static string[] country(string Country){
        ParkService.ParksImplPort  parks = new ParkService.ParksImplPort();
        string[] ParksName = parks.byCountry(Country);
        return ParksName;
    }
}