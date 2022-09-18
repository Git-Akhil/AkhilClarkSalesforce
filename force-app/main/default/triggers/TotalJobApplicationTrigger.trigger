trigger TotalJobApplicationTrigger on Job_Application__c (before insert) {
    
    
    Position__c[] polis = [select id from Position__c];
    
   
    
    
    
    /*for (Job_Application__c ja : trigger.new ){
        list<Position__c> polis = [select name from Position__c where  id = ja.name] ;
        system.debug('-----'+polis);
    }*/
    
    
    
     // map<id, Job_Application__c> mJa = new map<id,Job_Application__c>(jalis);

   // select  from Position__c where Name = 'POS - 00007    '
   // Position__c[] pos = [select id,Number_of_application__c from Position__c ];
    /*for(Job_Application__c Ja : trigger.new){
        if(Pos.Number_of_application__c > Pos.Max_Job_Application__c)
            Ja.addError('job Application are full on position');
        else
            update Ja.Number_of_application__c;
        
    }*/

}