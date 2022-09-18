public class MergePosJaBatchClass implements Database.Batchable<Sobject>,database.stateful{
    
    public Map<id,decimal> pidvsTotalJobapp = new map<id,decimal>();
    public map<id,decimal> pidvsOpencount = new map<id,decimal>();
    public map<id,decimal> pidvsClosecount = new map<id,decimal>();
    
    public string soqlQuery = '';
    
    public MergePosJaBatchClass(string Query){
        system.debug('----- inside Query Cons -----');
        this.soqlQuery = Query; 
    }
    
    Public Database.QueryLocator start(Database.BatchableContext Bc){
        system.debug('===== in start soqlQuery ====='+soqlQuery);
        return Database.getQueryLocator(soqlQuery);
    }
    
    Public void execute(Database.BatchableContext bc,list<sObject> sobjlist){
        if(sobjlist.size() > 0){
            sObject sobj = sobjlist[0];
            system.debug('===== inside execute sobj [0] ====='+sobj);
            if(sobj.getSObjectType().getdescribe().getname() == 'Job_Application__c'){
                system.debug('===== in execute if =====');
                jobAppLogic(sobjlist);
            }
            else if(sobj.getSObjectType().getdescribe().getname() == 'Position__c'){
                system.debug('===== in execute else =====');
                positionLogic(sobjlist);
            }
        }
    }
    
    Public void finish(Database.BatchableContext bc){
        system.debug('---pidvsTotalJobapp---'+pidvsTotalJobapp);
        system.debug('---pidvsOpencount---'+pidvsOpencount);
        system.debug('---pidvsClosecount---'+pidvsClosecount);
            
        MAP<Id,Position__c> posMAP = new MAP<Id,Position__c>();
        for(Id posID : pidvsTotalJobapp.keySet()){
            fillPositionMAPforUpdate(posMAP,pidvsTotalJobapp, posID, pidvsTotalJobapp.get(posID), 'Total');
        }
        for(Id posID : pidvsOpencount.keySet()){
            fillPositionMAPforUpdate(posMAP,pidvsOpencount, posID, pidvsOpencount.get(posID), 'Open');
        }
        for(Id posID : pidvsClosecount.keySet()){
            fillPositionMAPforUpdate(posMAP,pidvsClosecount, posID, pidvsClosecount.get(posID), 'Close');
        }
        system.debug('---posMAP---'+posMAP);
        if(posMAP.size()>0){
            Database.executeBatch(new SobjectUpdateBatch(posMAP.values()), 1);
        }
    }
    
    public void positionLogic(list<Position__c> PosObjList){
        For(Position__c posobj1 : PosObjList){
            integer oflag=0,cflag =0;
            if(posobj1.Job_Applications__r != Null && posobj1.Job_Applications__r.size() > 0){
                
                callUpdateMapLogic(posobj1.Job_Applications__r,oflag,cflag);
            }else{
                pidvsTotalJobapp.put(posobj1.id,0);
                pidvsOpencount.put(posobj1.Id, 0); 
                pidvsClosecount.put(posobj1.Id, 0);
            } 
        }
    }
        
    public void jobAppLogic(list<Job_Application__c> jobObjList){
        integer oflag=0,cflag =0;
        callUpdateMapLogic(jobObjList,oflag,cflag);
    }
    
    //Private Methods For Computation of busines Logic
    public void fillPositionMAPforUpdate(MAP<Id,Position__c> posMAP, Map<id,decimal> valueMap, Id posID, Decimal val, String var){
        Position__c pos = new Position__c();
        pos.Id = posID;
        if(posMAP.containskey(posID)){
            pos = posMAP.get(posID);
        } 
        if(var == 'Open'){
            pos.Total_Open_Pos__c = valueMap.get(posID) != null ? valueMap.get(posID) : 0 ;  
        }else if(var == 'Close'){
            pos.Total_Close_Pos__c = valueMap.get(posID) != null ? valueMap.get(posID) : 0 ;  
        }else if(var == 'Total'){
            pos.Total_JA__c = valueMap.get(posID) != null ? valueMap.get(posID) : 0 ;  
        }
        posMAP.put(posID, pos);
    }
    
//integer openflag = 0; 
//integer closeflag = 0;
    private void callUpdateMapLogic(list<Job_Application__c> jobObjList,integer oflg,integer cflg){
        
        for(Job_Application__c jobj : jobObjList){
            updateCountMAP( pidvsTotalJobapp, jobj.Position__c);
            if(jobj.Job_status__c == 'Open') {
                oflg++;
                updateCountMAP( pidvsOpencount, jobj.Position__c);
            }
            else if (jobj.Job_status__c == 'close'){
                cflg ++;
                updateCountMAP( pidvsClosecount, jobj.Position__c);
            }
       }
        /*if (oflg == 0){
            updateCountMAP( pidvsOpencount, jobj.Position__c);
        }*/ 
       //if(openflag == 0) pidvsOpencount.put(key, value)
    }

    private void updateCountMAP( map<id,decimal> pidvscount, ID posID){
        //if(openflag == 0)  pidvsOpencount.put(posID, 0);
        //if(closeflag == 0) pidvsClosecount.put(posID, 0);
        if(pidvscount.containsKey(posID)) 
            pidvscount.put(posID, pidvscount.get(posID)+1);
        else pidvscount.put(posID, 1); 
    } 

}