public with sharing class getpicklistClass {
   @AuraEnabled
   public static list<lead> getYearValues(string recId){
       list<lead> l = [SELECT Year__c FROM lead WHERE id=: recId];
       system.debug('----getpicklistclass lead l -----'+l);
       return (l);
   }

   @AuraEnabled
   public static list<yearindexWrapper> mypickList(string recId){

        try {
            list<string> mypick = new list<string>();
            Schema.DescribeFieldResult field = lead.Year__c.getDescribe();
            system.debug('-------field------'+field);

            
            for(Schema.PicklistEntry f : field.getPicklistValues()){
                system.debug('----inside picklist f.getlabel() -------'+f.getLabel());
                mypick.add(f.getLabel());
            }
            system.debug('-------for loop over mypick------'+mypick);
            
            list<yearindexWrapper> yi = new list<yearindexWrapper>();
            
            for(string yObj : mypick){
                yearindexWrapper wrapObj = new yearindexWrapper();
                
                wrapObj.year = yObj;
                system.debug('-----wrapObj.year = '+yObj);

                wrapObj.yIndex = 'Year'+yObj;
                system.debug('----- wrapObj.yIndex = '+wrapObj.yIndex);

                wrapObj.stateIndex = 'state'+yObj;
                system.debug('------ wrapObj.stateIndex -----'+ wrapObj.stateIndex );
                
                wrapObj.IRSIndex = 'IRS'+yObj;
                system.debug('------ wrapObj.IRSIndex -----'+ wrapObj.IRSIndex );

                yi.add(wrapObj);
            }
            //system.debug('-----after for loop list<yearindexWrapper> yi------',yi);

            return yi;
        } catch (Exception e) {
            system.debug('----found picklist error ----'+e);
            throw new AuraHandledException(e.getMessage());
        }
       
   }

   public class yearindexWrapper{
       @AuraEnabled public string year;
       @AuraEnabled public string yIndex;
       @AuraEnabled public string stateIndex;
       @AuraEnabled public string IRSIndex;
   }
}