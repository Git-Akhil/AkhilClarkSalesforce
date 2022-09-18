trigger NewTotalpositiontrigger on Position__c (before insert) {
    for (Position__c po : trigger.new){
        if (po.Number_of_application__c > po.Max_Job_Application__c){
            po.adderror(' application full');
        }
       
    }
}