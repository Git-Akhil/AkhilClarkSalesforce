public class backupmergebatchclass implements Database.Batchable<sObject>,database.stateful{
    public database.QueryLocator Start(Database.BatchableContext bc){
        Return Database.getQueryLocator('Select id,name,Total_JA__c,Total_Close_Pos__c,Total_Open_Pos__c,(Select id,name,Job_status__c,Position__c from Job_Applications__r) from Position__c');
    }
    public void Execute(Database.BatchableContext bc , list<sObject> sobj){
    
    }
    public void Finish(Database.BatchableContext bc){
        
    }
	
}