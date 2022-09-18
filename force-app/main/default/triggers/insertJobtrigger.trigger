trigger insertJobtrigger on Job_Application__c (before insert,before update) {
    
   //integer i = 10;
        
    if(trigger.isinsert){
    for(Job_Application__c ja : trigger.new ){
            ja.name = 'inserted '+ja.name;    
    }}
    if(trigger.isupdate){
    for(Job_Application__c ja : trigger.new ){
            ja.name = 'updated '+ja.name;    
    }}
       
        
}