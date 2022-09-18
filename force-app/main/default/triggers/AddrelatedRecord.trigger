trigger AddrelatedRecord on Account (After insert,After update) {
    list<Opportunity> opplist = new list<Opportunity>();
    
    for ( account a : [select id,name from account where id in : trigger.new and id not in (select accountid from opportunity)]){
        opplist.add(new Opportunity (name = a.name + 'opportunities' , StageName = 'prospecting' , CloseDate = system.today().addmonths(1) , accountid = a.Id));
        
    }
    if (opplist.size() > 0){
        insert opplist;
    }

}