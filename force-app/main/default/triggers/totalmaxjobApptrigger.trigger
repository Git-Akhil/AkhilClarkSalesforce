trigger totalmaxjobApptrigger on Job_Application__c (After insert,After update,After delete,after undelete){
    
    set<id> posiidset = new set<id>();
    if(trigger.isinsert || trigger.isupdate){  
        system.debug('=====inside insert update trigger=====');
        list<Job_Application__c> jlist = trigger.new;
        system.debug('===== inside insert update jlist ====='+jlist);
        
        for(Job_Application__c ja : jlist){
            system.debug('===== inside insert update for loop ja ====='+ja);
            posiidset.add(ja.Position__c);
            system.debug('===== inside insert update for loop add position id ====='+posiidset);
        }   
    }
    
    else if(trigger.isdelete || trigger.isundelete){   
        system.debug('===== inside delete undlete trigger =====');
        list<Job_Application__c> jlist = trigger.old;
        system.debug('===== inside delete undelete jlist ====='+jlist);
        
         for(Job_Application__c ja : jlist){
            system.debug('===== inside delete undelete for loop ja ====='+ja);
            posiidset.add(ja.Position__c);
            system.debug('===== inside delete undelete for loop add position id ====='+posiidset);
        }
    }
    system.debug('===== posiidset ====='+posiidset);
    
    map<id,list<Job_Application__c>> pidvsjamap = new map<id,list<Job_Application__c>>();
    for(Job_Application__c jlis : [select id,Position__c from Job_Application__c where Position__r.id = :posiidset])
        {
            system.debug('------jlis.Position__c-------'+jlis.Position__c);
            system.debug('------pidvsjamap-------'+pidvsjamap);
            if(pidvsjamap.get(jlis.Position__c) == null){
                list<Job_Application__c> newlist = new list<Job_Application__c>();
                newlist.add(jlis);
                system.debug('=====new list of null map jlis====='+newlist);
                pidvsjamap.put(jlis.Position__c, newlist);             
            }
            else{
                list<Job_Application__c> oldlist = pidvsjamap.get(jlis.Position__c);
                oldlist.add(jlis);
                system.debug('=====old list of null map jlis====='+oldlist);
                pidvsjamap.put(jlis.Position__c, oldlist);
            }
            system.debug('------inside for loop pidvsjamap-------'+pidvsjamap);
        }    
    
        system.debug('------for loop over pidvsjamap map ----> '+pidvsjamap);
    
        list<Position__c> totalja = new list<Position__c>();
        system.debug('===== totalja ====='+totalja);
        for(id posid :pidvsjamap.keySet()){
            system.debug('===== pidvsjamap.get(posid) ====='+pidvsjamap.get(posid));
            system.debug('===== posid inside for loop'+posid);
            Position__c po = new Position__c();
            po.id = posid;
            po.Total_JA__c = pidvsjamap.get(posid).size();
            system.debug('===== position object inside for loop - po =====' +po);
            totalja.add(po);
            system.debug('---- totalja ---- '+totalja);
        }
        update totalja;
        system.debug('===== for loop over list<Position__c> totalja ====='+totalja);
    

    list<Job_Application__c> joblist = [select id,Position__c,Job_status__c from Job_Application__c where Position__r.id = :posiidset];
    system.debug('====== joblist =====');
    map<id,list<Job_Application__c>> Tcjamap = new map<id,list<Job_Application__c>>();
    map<id,list<Job_Application__c>> Tojamap = new map<id,list<Job_Application__c>>();
    for(Job_Application__c jobj :joblist){
        system.debug('===== jobj open close map ====='+jobj);
        if(jobj.Job_status__c == 'Open'){
            system.debug('===== jobj.Job_status__c == Open ====='+jobj.Job_status__c);
            if(Tcjamap.get(jobj.Position__c) != null){
                System.debug('===== inside open if not null tojamap ===== '+Tojamap);
                system.debug('===== inside open if not null Tojamap.get(jobj.Position__c) '+Tojamap.get(jobj.Position__c));
                
                list<Job_Application__c> oldlist = Tojamap.get(jobj.Position__c);
                oldlist.add(jobj);
                system.debug('===== inside open if not null  ====='+oldlist);
                Tojamap.put(jobj.Position__c, oldlist);
                system.debug('===== inside open if not null tojamap ====='+Tojamap);
            }
            else{
                System.debug('===== inside open else null tojamap ===== '+Tojamap);
                system.debug('===== inside open else null Tojamap.get(jobj.Position__c) '+Tojamap.get(jobj.Position__c));
                list<Job_Application__c> newlist = new list<Job_Application__c>();
                newlist.add(jobj);
                system.debug('===== inside open else null  ====='+newlist);
                Tojamap.put(jobj.Position__c, newlist);
                 system.debug('===== inside open else tojamap ====='+Tojamap);
            }
        }
        else if(jobj.Job_status__c == 'Close'){
            if(Tcjamap.get(jobj.Position__c) != null){
                System.debug('===== inside Close if not null tcjamap ===== '+Tcjamap);
                system.debug('===== inside Close if not null Tcjamap.get(jobj.Position__c) '+Tcjamap.get(jobj.Position__c));
                list<Job_Application__c> oldlist = Tcjamap.get(jobj.Position__c);
                oldlist.add(jobj);
                system.debug('===== inside close if not null oldlist ====='+oldlist);
                Tcjamap.put(jobj.Position__c, oldlist);
                system.debug('===== inside close if not null Tcjamap ====='+Tcjamap);
            }
            else{
                System.debug('===== inside Close else null tcjamap ===== '+Tcjamap);
                system.debug('===== inside Close else null Tcjamap.get(jobj.Position__c) '+Tcjamap.get(jobj.Position__c));
                list<Job_Application__c> newlist = new list<Job_Application__c>();
                newlist.add(jobj);
                system.debug('===== inside close else null newlist ====='+newlist);
                Tcjamap.put(jobj.Position__c, newlist);
                system.debug('===== inside close else null Tcjamap ====='+Tcjamap);
            }
        }
    }
    system.debug('===== for loop over Tojamap ===== '+Tojamap);
    system.debug('===== for loop over Tcjamap ===== '+Tcjamap);
    
    list<Position__c> lastposlist = new list<Position__c>();
    
    for(id posobj : posiidset ){
        system.debug('===== inside for occount posobj ====='+posobj);
        system.debug('===== inside for occount Tojamap.get(posobj) ====='+Tojamap.get(posobj));
        system.debug('===== inside for occount Tcjamap.get(posobj) ====='+Tcjamap.get(posobj));
        Position__c occount = new Position__c();
        occount.id = posobj;
        system.debug('===== inside for occount occount.id ====='+occount.id);
        occount.Total_Open_Pos__c = Tojamap.get(posobj).size();
        system.debug('===== inside for occount occount.Total_Open_Pos__c ====='+occount.Total_Open_Pos__c);
        occount.Total_Close_Pos__c = Tcjamap.get(posobj).size();
        system.debug('=====  inside for occount occount.Total_Close_Pos__c  ====='+occount.Total_Close_Pos__c );
        system.debug('===== inside for occount ====='+occount);
        lastposlist.add(occount);  
        system.debug('===== inside for occount before update ====='+lastposlist);
    }
    update lastposlist;
    system.debug('===== for loop over after update  lastposlist ====='+lastposlist);
        /*else if(trigger.isdelete || trigger.isundelete){   
        system.debug('===== inside delete undlete trigger =====');
        list<Job_Application__c> jlist = trigger.old;
        system.debug('jlist ---> '+jlist);
        
        set<id> posiidset = new set<id>();
        for(Job_Application__c ja : jlist){
            posiidset.add(ja.Position__c);
        }
        system.debug('------posiidset-------'+posiidset);
    
    
        map<id,integer> pidvsjamap = new map<id,integer>();

        for(Job_Application__c jlis : [select id,Position__c,(select Total_JA__c from Position__r) from Job_Application__c where Position__r.id = :posiidset])
        {
            system.debug('------jlis.Position__c-------'+jlis.Position__c);
            system.debug('------pidvsjamap-------'+pidvsjamap);
            integer tempcount = pidvsjamap.get(jlis.Position__c);
            system.debug('------tempcount-------'+tempcount);
            if(tempcount == null)
            {
                tempcount = ;
            }    
            tempcount++;
            system.debug('------tempcount-------'+tempcount);
            pidvsjamap.put(jlis.Position__c, tempcount);
            system.debug('------pidvsjamap-------'+pidvsjamap);
        }    
    
        system.debug('------ pidvsjamap map ----> '+pidvsjamap);
        
        list<Position__c> totalja = new list<Position__c>();
        system.debug('===== totalja ====='+totalja);
        for(id posid :pidvsjamap.keySet()){
            Position__c po = new Position__c();
            po.id = posid;
            po.Total_JA__c = pidvsjamap.get(posid);
            
            totalja.add(po);
            system.debug('---- totalja ---- '+totalja);
            
        }
        update totalja;
        system.debug('------ list<Position__c> totalja ---->'+totalja);  
        
    }*/
    
    
    /*for(Job_Application__c ja : jlist){
        posiidset.add(ja.Position__c);
    }
    system.debug('------posiidset-------'+posiidset);
    
    
    map<id,integer> pidvsjamap = new map<id,integer>();

    for(Job_Application__c jlis : [select id,Position__c from Job_Application__c where Position__r.id = :posiidset])
    {
        system.debug('------jlis.Position__c-------'+jlis.Position__c);
        system.debug('------pidvsjamap-------'+pidvsjamap);
        integer tempcount = pidvsjamap.get(jlis.Position__c);
        system.debug('------tempcount-------'+tempcount);
        if(tempcount == null)
        {
            tempcount = 0;
        }    
        tempcount++;
        system.debug('------tempcount-------'+tempcount);
        pidvsjamap.put(jlis.Position__c, tempcount);
        system.debug('------pidvsjamap-------'+pidvsjamap);
    }    
    
    system.debug('------ pidvsjamap map ----> '+pidvsjamap);
    
    
    
    list<Position__c> totalja = new list<Position__c>();
    system.debug('===== totalja ====='+totalja);
    for(id posid :pidvsjamap.keySet()){
        Position__c po = new Position__c();
        po.id = posid;
        po.Total_JA__c = pidvsjamap.get(posid);
        
        totalja.add(po);
        system.debug('---- totalja ---- '+totalja);
        
    }
    update totalja;
    system.debug('------ list<Position__c> totalja ---->'+totalja);  
    */
    
    
    /*if(po.Total_JA__c > po.Max_Job_Application__c){
            system.debug('------------------------------inside add error if loop----------------------------------------------------');
             po.adderror('rich max limit of job application');
            
        }*/
    //list<Position__c> positionobj = [select id,name,Max_Job_Application__c from Position__c where id = :pidvsjamap.keySet()];
    //list<Position__c> maxja = new list<Position__c>();
                   
    
    
    //-------------------------------------------------total open total close----------------------------------------------------
    
    /*map<id,Position__c> pidvsstatus = new map<id,Position__c>([select id,Status__c from Position__c where id in :posiidset]);
    system.debug('----- pidvsstatus   map----- '+pidvsstatus);
    map<id,integer> Tcjamap = new map<id,integer>();
    map<id,integer> Tojamap = new map<id,integer>();
    //set<string> posiidset = new set<string>();
    integer sumopenstatus = 0;
    integer sumclosestatus = 0;
        
    for(Job_Application__c j : trigger.new){
        if(pidvsstatus.containsKey(j.Position__c)){
            //for(Position__c posid : [select id from Position__c where id = :j.Position__c]){
            if(pidvsstatus.get(j.Position__c).Status__c == 'Open'){
                system.debug('------ inside sum open status ----- ');
                sumopenstatus += 1;
                system.debug('sum open status'+sumopenstatus);
            }
            else if(pidvsstatus.get(j.Position__c).Status__c == 'Close'){
                system.debug('------ inside sum close status ----- ');
                sumclosestatus += 1;
                system.debug('sum close status'+sumopenstatus);
            }
            
            /*else if(pidvsstatus.get(j.Position__c).Status__c == 'New' or pidvsstatus.get(j.Position__c).Status__c == 'null'){
                
            }
        }
        Tcjamap.put(j.Id, sumopenstatus);
        Tojamap.put(j.Id, sumclosestatus);
    }
    system.debug('----- total open count map -----'+Tcjamap);
    system.debug('----- total open count map -----'+Tojamap);
    
    list<Job_Application__c> jaoclist = new list<Job_Application__c>();
    for(Job_Application__c jobj : trigger.new){
        Job_Application__c jo = new Job_Application__c();
        jo.id = jobj.id;
        jo.Total_Close_Pos__c = Tcjamap.get(jobj.Id);
        jo.Total_Open_Pos__c = Tojamap.get(jobj.id);
        jaoclist.add(jo);
    }
    update jaoclist;
    system.debug('job app open close final list'+jaoclist);*/
}