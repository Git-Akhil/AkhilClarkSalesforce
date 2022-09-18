trigger sumofcountTrigger on Job_Application__c (after insert,after update) {
    
    list<Job_Application__c> jalis = trigger.new;
    system.debug('jalis values -- ' +jalis);
    set<string> positionid = new set<string>();
    
    // adding id in set of job application
    for(Job_Application__c j : jalis){
        positionid.add(j.Position__c);
    }
    system.debug('inside 1 for loop -- '+positionid);
    system.debug('1 for loop over');
    
    // list of total job application
    list<Job_Application__c> newjalist =[select Position__c,count_of_app__c from Job_Application__c where Position__r.id in :positionid];
    system.debug('newjalist -- '+newjalist);
    
    //map of id and there job Application
    map<id,list<Job_Application__c>> positionvslistjamap = new map<id,list<Job_Application__c>>();
    system.debug('positionvslistjamap -- '+positionvslistjamap);
    
    for(Job_Application__c ja : newjalist){
        if(positionvslistjamap.get(ja.Position__c)!=null){
            list<Job_Application__c> oldja = positionvslistjamap.get(ja.Position__c);
            oldja.add(ja);
            system.debug('2 for --> if --> oldja -- '+oldja);
            positionvslistjamap.put(ja.Position__c, oldja);
        }
        else{
            list<Job_Application__c> newpartja = new list<Job_Application__c>();
            newpartja.add(ja);
            system.debug('2 for --> else --> newpartja -- '+newpartja);
            positionvslistjamap.put(ja.Position__c,newpartja );
        }
    }
    system.debug('2 for --> else --> positionvslistjamap.put -- '+positionvslistjamap);
    system.debug('2 for loop over');
    
    //create new map of position id and sum
    map<id,decimal> positionidvsjasum = new map<id,decimal>();
    system.debug('map positionidvsjasum created');
    
    // sum of job application according to there id
    for (id posid : positionvslistjamap.keySet()){
        decimal sum = 0;
        for(Job_Application__c ja1 : positionvslistjamap.get(posid)){
            if(ja1.count_of_app__c == null){
                ja1.count_of_app__c = 0;
                system.debug('3 for --> if -- ');
            }
            sum += ja1.count_of_app__c;
            system.debug('3 for --> sum --> '+sum);
        }
        positionidvsjasum.put(posid, sum);
    }
    system.debug('3 for outer --> positionidvsjasum.put(posid, sum) --> '+positionidvsjasum);
    system.debug('3 for loop over');
     
    //create list of position for sum of their application
    list<Position__c> positionlist = new list<Position__c>();
    system.debug('positionlist created --> '+positionlist);
    
    for(id pos : positionidvsjasum.keySet()){
        Position__c p = new Position__c();
        p.id = pos;
        p.sum_of_position__c = positionidvsjasum.get(pos);
        positionlist.add(p);
        system.debug('4 for loop --> p.id --> '+p);
    }
    system.debug('4 for loop --> p.positionlist.add(p) --> '+positionlist);
    update positionlist;

}