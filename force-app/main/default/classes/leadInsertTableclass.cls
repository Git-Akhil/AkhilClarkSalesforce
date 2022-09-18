public with sharing class leadInsertTableclass {
    
    @AuraEnabled
    public static List<string> getLeadstatusValues(){
        try {
            List<string> statusValues = new List<string>();
            schema.DescribeFieldResult field = lead.Status.getDescribe();
            System.debug('----- lead field -----'+field);
            

            for(schema.PicklistEntry obj : field.getPicklistValues()){
                system.debug('----inside for obj.getLabel()-----'+obj.getLabel());
                statusValues.add(obj.getLabel());
            }
            system.debug('-------for loop over statusValues------'+statusValues);
            
            return statusValues;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<lead> getLeadList(){
        try {
            list<lead> ListOfLead = [SELECT id,FirstName,LastName,Company,Email,Status,Date_Record_Insert__c FROM Lead WHERE CreatedDate = TODAY AND HOUR_IN_DAY(LastModifiedDate) > 1 ];
            System.debug('------ListOfLead-----'+ListOfLead);
            return ListOfLead;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Lead createLeadRecord(Lead l){
        try {
            system.debug('---lead l---'+l);
            insert l;
            return l;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static list<lead> saveLeadInserttable(list<lead> leadlst){
        try {
            system.debug('----- list<lead> '+leadlst );
            system.debug('----- list<lead>.length '+leadlst.size() );
            insert leadlst;
            return leadlst;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}