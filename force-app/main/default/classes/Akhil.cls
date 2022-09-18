public class Akhil {
    public static void callInit(){
        
        Harshil h = new Harshil();
        String mAkhilName = h.callInit();
        System.debug('mAkhilName: '+mAkhilName);
        
        Harshil h2 = new Harshil('Harshil');
        String mHarshilName = h2.callInit();
        System.debug('mHarshilName: '+mHarshilName);
        
        Harshil h3 = new Harshil('Deep');
        String mDeepName = h3.callInit();
        System.debug('mDeepName: '+mDeepName);
        
        String message = Harshil.sayYou('Akhil');
        System.debug('message: '+message);
        String name = Harshil.AKHIL;
        System.debug('name: '+name);
    }
}