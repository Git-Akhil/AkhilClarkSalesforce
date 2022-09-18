public class Toaster implements KitchenUtility {
	private String modelnumber='mn-02';
    
    /*public Toaster(string amodelnumber){
        modelnumber = amodelnumber;
    }*/
    public Toaster(){
        system.debug('default con called');
    }
     public string getmodelnumber(){
        return 'T'+modelnumber;
    }
    
   
}