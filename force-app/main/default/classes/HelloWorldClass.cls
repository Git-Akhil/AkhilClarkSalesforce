public with sharing class HelloWorldClass {


    @AuraEnabled
    public static Decimal  doSum(Decimal d1, Decimal d2){
        try {
            return d1 + d2;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}