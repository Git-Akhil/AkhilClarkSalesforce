trigger maxjatrigger on Job_Application__c (before insert) {
    system.debug('--------------------before trigger of job application---------------------------------------------');
    
    set<id> posid = new set<id>();
    for(Job_Application__c jn : trigger.new){
        if(jn.Position__c != null){
            posid.add(jn.Position__c);
        }
    }
    system.debug('set of position id ---> '+posid);
   
    MAP<Id,Position__c> posMap = new MAP<ID,Position__c>([select id,name,Total_JA__c,Max_Job_Application__c from Position__c where id in :posid]);
    
    
    for(Job_Application__c jn : trigger.new){
        if(posMap.containsKey(jn.Position__c)){
            if(posMap.get(jn.Position__c).Max_Job_Application__c <= posMap.get(jn.Position__c).Total_JA__c){
                jn.adderror('no longer accepting job ');
            }
        }
    }
}