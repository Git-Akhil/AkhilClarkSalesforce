@isTest
public class availableConfigControllerTest {
    @testSetup
    public static void makeData(){
        Test.setMock(HttpCalloutMock.class, new configCalloutResponseGenerator());
        Account accObj = new Account();
        accObj.Name = 'Test Acc';
        insert accObj;

        Contact con = new Contact();
        con.LastName = 'Test';
		con.AccountId = accObj.Id;
        con.Email = 'test@gmail.com';
        insert con;

        Case caseObj = new Case();
        caseObj.Status = 'New';                                          
        caseObj.Priority = 'High';                                           
        caseObj.ContactId = con.Id;                                        
        caseObj.Type = 'Electrical';                                            
        caseObj.Origin = 'Phone';                                          
        caseObj.Reason = 'Performance';                 
        insert caseObj;
        
        Case_Config__c CaseConfigObj = new Case_Config__c();
        CaseConfigObj.Label__c = 'test1label';  
        CaseConfigObj.Type__c = 'Test1type';     
        CaseConfigObj.Amount__c = 26.00;   
        CaseConfigObj.Case__c = caseObj.Id;
        insert CaseConfigObj;
 
        List<Config__c> configList = new List<Config__c>();
        for(Integer i=1; i <= 100; i++){
            Config__c configObj = new Config__c();
            configObj.Name = 'Config'+i;
            configObj.Label__c = 'Label_'+i;  
            configObj.Type__c = 'type'+i;     
            configObj.Amount__c = 26.00 + +i;   
            configList.add(configObj);
        }
        insert configList;

    }

    @isTest
    public static void getAllConfigDataTest(){

        Test.startTest();
        List<Config__c> lstOfConfigData = availableConfigController.getAllConfigData();
        Test.stopTest();
    }

    @isTest
    public static void getAllCaseConfigDataTest(){
        Case caseRec = [SELECT Id FROM Case LIMIT 1];

        Test.startTest();
        List<Case_Config__c> lstOfCaseConfig = availableConfigController.getAllCaseConfigData(caseRec.Id);
        Test.stopTest();
    }
	
    @isTest
    public static void backendCallTest(){
        Case caseRec = [SELECT Id FROM Case LIMIT 1];
        List<Config__c> selectedConfigIds = [SELECT Id FROM Config__c LIMIT 10];
        List<String> configIds = new List<String>();
        for(Config__c obj: selectedConfigIds){
            configIds.add(obj.Id);
        }

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new configCalloutResponseGenerator());
        Integer responseStatusCode = availableConfigController.backendCall(caseRec.Id,JSON.Serialize(configIds));
        Test.stopTest();
    }
}