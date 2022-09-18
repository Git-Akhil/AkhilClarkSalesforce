public with sharing class fieldRouteclassAkhil {
    @AuraEnabled 
    public static List<Account> getOfficeLocations(String accountNameInitial){
        String str = accountNameInitial + '%';
        return [SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry 
                FROM Account 
                WHERE Name LIKE :str];       
    }
}