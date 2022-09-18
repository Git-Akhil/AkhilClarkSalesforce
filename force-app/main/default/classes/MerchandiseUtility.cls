public class MerchandiseUtility {
    public static void mainprocessing(){
        try{
            insertmerchandise();
        }
        catch(Merchandiseexception me){
            system.debug('Message -- '+me.getMessage());
            system.debug('Type -- '+me.gettypename());
            system.debug('cause -- '+me.getCause());
            system.debug('Line Number -- '+me.getLineNumber());
            system.debug('stack trace  -- '+me.getstacktracestring());
        }
    }
    
    public static void insertmerchandise(){
        try{
            Merchandise__c m = new Merchandise__c();
            insert m;
        }
        catch(DMLexception e){
            throw new merchandiseException('merchandise item could not be inserted.',e);
        }
    }
}