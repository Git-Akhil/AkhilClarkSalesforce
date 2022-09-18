public class trialtotaljobapp implements database.Batchable<sobject>//------------sobject why
{
	map<id,list<Job_Application__c>> pidvsjobapp = new map<id,list<Job_Application__c>>();
    map<id,list<Job_Application__c>> pidvstoja = new map<id,list<Job_Application__c>>();
    map<id,list<Job_Application__c>> pidvstcja = new map<id,list<Job_Application__c>>();
    //----------------iterable<sobject> ,query , querylocator diff
    public database.QueryLocator start(database.BatchableContext bc){
        //list<Position__c> poslist = [select id,name from Position__c ];
        system.debug('===== inside start =====');
        system.debug('===== bc.getChildJobId() ====='+bc.getChildJobId());
        system.debug('===== bc.getJobId() ====='+bc.getJobId());
        set<id> posidset = new set<id>();
        system.debug('===== in start before add - podidset size ===== '+posidset.size());
        for(Job_Application__c job : [select id,name,Position__c from Job_Application__c WHERE CreatedDate >= LAST_N_DAYS:2 or LastModifiedDate >= LAST_N_DAYS:2]){
            system.debug('===== in start inside for job id  ===== '+job.Name);
            posidset.add(job.Position__c);
            system.debug('===== in start inside for after add - podidset size ===== '+posidset.size());
        }
        system.debug('===== in start after add - podidset size ====='+posidset);
        system.debug('===== in start after add - podidset size ===== '+posidset.size());
        return database.getQueryLocator([select id,Position__c,Job_status__c from Job_Application__c where  Position__r.id = :posidset]);
    }
    
    public void execute(database.BatchableContext bc , list<Job_Application__c> ja){
        system.debug('===== list of job app ====='+ja);
        system.debug('======size of list of job app ====='+ja.size());
        
        
        for(Job_Application__c jafor : ja){
            system.debug('===== inside for jafor =====');
            if(pidvsjobapp.get(jafor.Position__c)==null){
                list<Job_Application__c> newlist = new list<Job_Application__c>();
                newlist.add(jafor);
                system.debug('===== inside for if new list ====='+newlist);
                pidvsjobapp.put(jafor.Position__c,newlist);
            }
            else{
                system.debug('===== inside for else oldlist ja before add ====='+pidvsjobapp.get(jafor.Position__c));
                list<Job_Application__c> oldlist = pidvsjobapp.get(jafor.Position__c);
                oldlist.add(jafor);
                system.debug('===== inside for else oldlist ja after add ====='+oldlist);
                pidvsjobapp.put(jafor.Position__c,oldlist);
                system.debug('===== inside for else pidvsjobapp ja after add map ====='+pidvsjobapp);
            }
        }
        system.debug('====== for loop over pidvsjobapp map ======'+pidvsjobapp);
        
        
        for(Job_Application__c joc : ja){
            
            if(joc.Job_status__c == 'Open'){
                system.debug('===== inside for if open =====');
                if(pidvstoja.get(joc.Position__c) != null){
                    system.debug('===== inside for if open if not null =====');
                    system.debug('===== inside for if open if not null ====='+joc.Position__c);
                    list<Job_Application__c> oldjalist = pidvstoja.get(joc.Position__c);
                    oldjalist.add(joc);
                    system.debug('===== inside for if open if not null oldjalist after add ja ====='+oldjalist);
                    pidvstoja.put(joc.Position__c,oldjalist);
                }
                else{
                    system.debug('===== inside for if open else null =====');
                    system.debug('===== inside for if open else null ====='+joc.Position__c);
                    list<Job_Application__c> newjalist = new list<Job_Application__c>();
                    newjalist.add(joc);
                    system.debug('===== inside for if open else null newjalist after add ja ====='+newjalist);
                    pidvstoja.put(joc.Position__c,newjalist);
                }
                
            }
            else if(joc.Job_status__c == 'Close'){
				system.debug('===== inside for else_if close =====');
                if(pidvstcja.get(joc.Position__c) != null){
                    system.debug('===== inside for else_if close if not null =====');
                    system.debug('===== inside for else_if close if not null joc.Position__c ====='+joc.Position__c);
                    list<Job_Application__c> oldjalist = pidvstcja.get(joc.Position__c);
                    oldjalist.add(joc);
                    system.debug('===== inside for else_if close if not null oldjalist after add ja ====='+oldjalist);
                    pidvstcja.put(joc.Position__c,oldjalist);
                }
                else{
                    system.debug('===== inside for else_if close else null =====');
                    system.debug('===== inside for else_if close else null joc.Position__c ====='+joc.Position__c);
                    list<Job_Application__c> newjalist = new list<Job_Application__c>();
                    newjalist.add(joc);
                    system.debug('===== inside for else_if close else null newjalist after add ja ====='+newjalist);
                    pidvstcja.put(joc.Position__c,newjalist);
                }
            }
        }
        system.debug('=====  For loop over Map pidvstoja after put ====='+pidvstoja);
        system.debug('=====  For loop over Map pidvstcja after put ====='+pidvstcja);
        
        list<Position__c> poslist = new list<Position__c>();
        for(id jid : pidvsjobapp.keyset() ){
            system.debug('===== inside for jid ====='+jid);
            Position__c pobj = new Position__c(); 
            pobj.id = jid;
            system.debug('===== inside for pobj.id ====='+pobj.id);
            pobj.Total_JA__c = pidvsjobapp.get(jid).size();
            system.debug('===== inside for pobj.Total_JA__c ====='+pobj.Total_JA__c);
            system.debug('===== inside for pobj ====='+pobj);
            if(pidvstoja.get(jid) != null){
            	pobj.Total_Open_Pos__c = pidvstoja.get(jid).size();
                system.debug('===== inside for pobj.Total_Open_Pos__c  ====='+pobj.Total_Open_Pos__c );
            }
            
            if(pidvstcja.get(jid) !=null){
            	pobj.Total_Close_Pos__c = pidvstcja.get(jid).size();
                system.debug('===== inside for pobj.Total_Close_Pos__c  ====='+pobj.Total_Close_Pos__c );
            }
            
            poslist.add(pobj);
        }
        system.debug('===== for loop over poslist before update ====='+poslist);
        system.debug('===== for loop over poslist Size before update  ====='+poslist.size());
		update poslist;
        system.debug('===== for loop over poslist after update ====='+poslist);
        system.debug('===== for loop over poslist Size After update  ====='+poslist.size());

    }
    public void finish(database.BatchableContext bc){
        system.debug('===== finish =====');
    }

}