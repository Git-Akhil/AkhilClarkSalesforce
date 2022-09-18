trigger totalpositiontrigger on Position__c (before insert , before update) {
    
    integer maximum = 5;
    for (Position__c po : trigger.new){
        if (po.Number_of_application__c > maximum){
            po.adderror(' application full');
        }
        else if(trigger.isinsert){
            maximum += 1;
        }
        else if( po.IsDeleted ){
                maximum -= 1;
        }
    }

}