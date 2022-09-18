trigger ClosedOpportunityTrigger on Opportunity (After insert,After update) {
    list<Task> listtask = new list<Task>();

    for(Opportunity obj :[select id,name,Stagename  from Opportunity where id in : Trigger.new And Stagename  = 'Closed Won' ]){
        task newtask = new task();
        newtask.Subject =  'Follow Up Test Task';
        newtask.WhatId = obj.Id;
		listtask.add(newtask);        
    }
    insert listtask;  
}