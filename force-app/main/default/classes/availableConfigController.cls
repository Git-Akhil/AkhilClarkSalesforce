public class availableConfigController {
	@AuraEnabled
    public static List<Config__c> getAllConfigData(){
        try {
            List<Case_Config__c> lstOfCaseConfig = [SELECT Id, Label__c FROM Case_Config__c];
            List<String> listOfCaseConfigLabel = new List<String>();
            for(Case_Config__c obj : lstOfCaseConfig){
                listOfCaseConfigLabel.add(obj.Label__c);
            }

            List<Config__c> lstOfConfigData = [SELECT Id, Name, Label__c, Type__c, Amount__c FROM Config__c WHERE Label__c NOT IN: listOfCaseConfigLabel];

            return lstOfConfigData;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Integer backendCall(String caseId, String selectedConfigIdsString){
        try {
            List<String> selectedConfigIds = (List<String>)JSON.deserialize(selectedConfigIdsString, List<String>.class);

            List<Config__c> selectedConfigIRecord = [SELECT Id, Name, Label__c, Type__c, Amount__c FROM Config__c WHERE Id IN: selectedConfigIds];

            String payLoad = createPayload(caseId, selectedConfigIRecord);

            Integer responseStatusCode = doCallout(payLoad);

            // Insert config rec
            List<Case_Config__c> caseConfigList = new List<Case_Config__c>();

            if(responseStatusCode != null && responseStatusCode == 200){
                for(Config__c configObj: selectedConfigIRecord){
                    Case_Config__c CaseConfigObj = new Case_Config__c();
                    if(caseId != null){
                        CaseConfigObj.Label__c = configObj.Label__c;
                        CaseConfigObj.Type__c = configObj.Type__c;
                        CaseConfigObj.Amount__c = configObj.Amount__c;
                        CaseConfigObj.Case__c = caseId;
                        caseConfigList.add(CaseConfigObj);
                    }
                }
    
                if(!caseConfigList.isEmpty()){
                    insert caseConfigList;
                }
                return responseStatusCode;
            }
            return null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static Integer doCallout(String payload){
        try{
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint('https://testapi1.requestcatcher.com/test');
            req.setBody(payload);
        
            HttpResponse res = new Http().send(req);
            System.debug('res.getStatusCode():: '+res.getStatusCode());
            System.debug('res.getBody():: '+res.getBody());
            return res.getStatusCode();
        }
        catch(Exception e){
            System.debug('(e.getMessage()>>> '+e.getMessage());
        }
        return null;
    }

    @AuraEnabled
    public static List<Case_Config__c> getAllCaseConfigData(String recordId){
        try {
            system.debug('recordId---'+recordId);
            List<Case_Config__c> lstOfCaseConfig = [SELECT Id, Name, Label__c, Type__c, Amount__c, Case__c FROM Case_Config__c WHERE Case__c =: recordId];

            return lstOfCaseConfig;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static String createPayload(String caseId, List<Config__c> selectedConfigIRecord){
        // for Call Out body
        List<caseConfigWrapper> caseConfigWrapperList = new List<caseConfigWrapper>();
        for(Config__c configObj: selectedConfigIRecord){
            caseConfigWrapper wrapperObj = new caseConfigWrapper();
            wrapperObj.Label = configObj.Label__c;
            wrapperObj.type = configObj.Type__c;
            wrapperObj.amount = configObj.Amount__c;
            caseConfigWrapperList.add(wrapperObj);
        }        
        
        caseWrapper wrapperObj = new caseWrapper();
        wrapperObj.Id = caseId;
        wrapperObj.Status = 'Close';
        if(!caseConfigWrapperList.isEmpty()){
            wrapperObj.caseConfigs = caseConfigWrapperList;
        }
        return JSON.Serialize(wrapperObj);
    }


    public class caseWrapper {
        @AuraEnabled
        public String Id { get; set; }
        @AuraEnabled
        public String Status { get; set; }
        @AuraEnabled
        public List<caseConfigWrapper> caseConfigs { get; set; }
    }

    public class caseConfigWrapper{
        @AuraEnabled
        public String Label { get; set; }
        @AuraEnabled
        public String type { get; set; }
        @AuraEnabled
        public Decimal amount { get; set; }
    }

}