trigger rejectUndereducatedTrigger on Job_Application__c (before insert,before update) {
    for(Job_Application__c JA : trigger.new){
        Position__c getback = [select Name from Position__c where id = : JA.Position__c];
        if ( JA.Candidate_Qualified__c == 'not qualified'){
            JA.adderror('you are not allowed to apply without proper educational requirement');
        }
    }

}