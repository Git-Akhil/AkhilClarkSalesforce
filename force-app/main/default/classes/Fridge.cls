public class Fridge implements KitchenUtility{	
    
    public static final integer stockthreshold= 50;
    private string modelnumber;
    private integer numberinstock;
    
    Public integer ecorating{
        get{return ecorating;}
        set{ecorating = value; if (ecorating<0) ecorating=0;}
    }
    
    public static void toDebug(Fridge afridge){
        system.debug('model number = '+afridge.modelnumber);
    	system.debug(' number in stock = '+afridge.numberinstock);
	}
    
    public static string getmodelnumber(fridge amodel){
        return amodel.modelnumber;
    }    
    
    public Fridge(){
        modelnumber='xx-xx';
        numberinstock=0;
        system.debug('number -- '+modelnumber+ '-- stock -- '+numberinstock);
    }
    public  Fridge(string themodelnumber,integer thenumberinstock){
        modelnumber = themodelnumber;
        numberinstock = thenumberinstock;
        system.debug('number -- '+modelnumber+'-- stock -- '+numberinstock);
    }
    
    public void updatestock(integer justsold){
        numberinstock = numberinstock - justsold;
        system.debug('remaing stock'+numberinstock);
    }
    
    public void setmodelnumber(string themodelnumber){
        modelnumber = themodelnumber;
    }
    public string getmodelnumber(){
        system.debug('model number');
        return modelnumber;
    }
}