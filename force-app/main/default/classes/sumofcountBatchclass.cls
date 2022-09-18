public class sumofcountBatchclass implements Database.Batchable<sobject>,Database.stateful {
    map<id,decimal> pidVscountja = new  map<id,decimal>();
    
    public Database.QueryLocator Start(Database.BatchableContext bc){
        return Database.getQueryLocator('select id,name,count_of_app__c,Position__c from Job_Application__c');
    }
    public void execute(Database.BatchableContext bc, List<Job_Application__c> jalist){
        //add value and position id to map
        for (Job_Application__c JAobj: jalist){
            if(JAobj.count_of_app__c != null)
            	callupdatepidVscountja(pidVscountja,JAobj.Position__c,JAobj.count_of_app__c);
        }
    }
    public void finish(Database.BatchableContext bc){
        system.debug(' ----- pidVscountja ----- '+pidVscountja);
        //create list of position id and value
        list<Position__c> posIdvaluelist = new list<Position__c>();
        for(id posid : pidVscountja.keySet()){
            fillposIdvaluelist(posid,pidVscountja.get(posid),posIdvaluelist);
        }
        system.debug(' ----- posIdvaluelist ----- '+posIdvaluelist);
        update posIdvaluelist;
    }
    
    // Private Methods For Computation
     private void callupdatepidVscountja(map<id,decimal> MapidvsValue ,id posid,decimal value){
        if(MapidvsValue.containskey(posid)){
        	decimal getcountfromMAp = MapidvsValue.get(posid);
        	MapidvsValue.put(posid, getcountfromMAp +  value);
        }
        else MapidvsValue.put(posid, value);
    }
    private void fillposIdvaluelist(id IdofPosition , decimal countvalue , list<Position__c> idvaluelist){
        Position__c posobj = new Position__c();
        posobj.Id = IdofPosition;
        posobj.sum_of_position__c = countvalue;
        idvaluelist.add(posobj);
    }

}




////if(pidVscountja.containsKey(JAobj.Position__c)){
//decimal getcountfromMAp = pidVscountja.get(JAobj.Position__c);
                    //pidVscountja.put(JAobj.Position__c, getcountfromMAp + JAobj.count_of_app__c );
                //}
                //else{
                    //pidVscountja.put(JAobj.Position__c, JAobj.count_of_app__c );
                //}
 /*Position__c posobj = new Position__c();
            posobj.Id = posid;
            posobj.sum_of_position__c = pidVscountja.get(posid);
            posIdvaluelist.add(posobj);*/