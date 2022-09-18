public class newtotalocjabatchclass implements database.Batchable<sobject>, Database.Stateful{
    public Map<id,decimal> pidvsTotalJobapp = new map<id,decimal>();
    public map<id,decimal> pidvsOpencount = new map<id,decimal>();
    public map<id,decimal> pidvsClosecount = new map<id,decimal>();
    
    public  Iterable<Sobject> start(Database.BatchableContext bc){
        return [select id,name,Position__c,Job_status__c from Job_Application__c];
    }
    
    public void Execute(Database.BatchableContext bc,list<Job_Application__c> jobList){
        callfillmap(joblist);
    }
    
     public void Finish(Database.BatchableContext bc){
        system.debug('===== inside finish Total job App Map ====='+pidvsTotalJobapp +'\n ===== inside finish open job App Map ====='+pidvsOpencount +'\n ===== inside finish Close job App Map ====='+pidvsClosecount);
        map<id,Position__c> idvsposvalueMap = new  map<id,Position__c>();
        for(id totalobj : pidvsTotalJobapp.keyset()){
            addidandpositiontoMap(idvsposvalueMap,pidvsTotalJobapp,totalobj,pidvsTotalJobapp.get(totalobj),'total');
        }
        for(id totalobj : pidvsOpencount.keyset()){
            addidandpositiontoMap(idvsposvalueMap,pidvsOpencount,totalobj,pidvsOpencount.get(totalobj),'Open');
        }
        for(id totalobj : pidvsClosecount.keyset()){
            addidandpositiontoMap(idvsposvalueMap,pidvsClosecount,totalobj,pidvsClosecount.get(totalobj),'Close');  
        }
        system.debug('===== inside finish Total job App Map after put value ====='+idvsposvalueMap);
    }
    
    // private methods for computation..............
    private void addidandpositiontoMap(map<id,Position__c> newIDvsPosMap,Map<id,decimal> PosValueMap,id PosId,decimal count,string Var){
        Position__c positionObj = new Position__c();
        positionObj.Id = PosId;
        if (newIDvsPosMap.containskey(PosId)){
            positionObj = newIDvsPosMap.get(PosId);
        }
        if(var == 'Total'){
            positionObj.Total_JA__c = PosValueMap.get(PosId) != null ? PosValueMap.get(PosId) : 0;
        }
        if(var == 'Open'){
            positionObj.Total_JA__c = PosValueMap.get(PosId) != null ? PosValueMap.get(PosId) : 0;
        }
        if(var == 'Close'){
            positionObj.Total_JA__c = PosValueMap.get(PosId) != null ? PosValueMap.get(PosId) : 0;
        }
        newIDvsPosMap.put(PosId,positionObj);
    }
  
    private void callfillmap(list<Job_Application__c> listjobapplication){
        for(Job_Application__c total : listjobapplication){
             putidvsvaluemap(pidvsTotalJobapp,total.Position__c);
            
            if(total.Job_status__c == 'Open'){
                 putidvsvaluemap(pidvsOpencount,total.Position__c);  
            }
            else if(total.Job_status__c == 'close'){
                putidvsvaluemap(pidvsClosecount,total.Position__c);
            } 
        }
    }
    private void putidvsvaluemap(Map<id,decimal> idvsvalueMap,id posid){
        if(idvsvalueMap.containskey(posid)){
        	decimal totalja = idvsvalueMap.get(posid);
        	idvsvalueMap.put(posid,totalja+1);
        }
        else idvsvalueMap.put(posid,1);
    }
}


/*if(pidvsTotalJobapp.get(total.Position__c) != null){
               
                /*decimal totalja = pidvsTotalJobapp.get(total.Position__c);
                pidvsTotalJobapp.put(total.Position__c,totalja+1);
            }
            else{ 
                pidvsTotalJobapp.put(total.Position__c,1); 
            }*/
/*if(pidvsOpencount.get(total.Position__c) != Null){ 
                    decimal opencount = pidvsOpencount.get(total.Position__c);
                    pidvsOpencount.put(total.Position__c, opencount+1); 
                }
                Else{ 
                    	pidvsOpencount.put(total.Position__c, 1);
                    }  */
/*if(pidvsClosecount.get(total.Position__c) != Null){ 
                    decimal Closecount = pidvsClosecount.get(total.Position__c);
                    pidvsClosecount.put(total.Position__c, Closecount+1);
                }
                Else{ 
                    pidvsClosecount.put(total.Position__c, 1); 
                } */
 /*for(Job_Application__c total : jobList){
            if(pidvsTotalJobapp.get(total.Position__c) != null){
                decimal totalja = pidvsTotalJobapp.get(total.Position__c);
                pidvsTotalJobapp.put(total.Position__c,totalja+1);
            }
            else{ 
                pidvsTotalJobapp.put(total.Position__c,1); 
            } 
        }*/
/*Position__c positionObj = new Position__c();
            positionObj.Id = totalobj;
            if (idvsposvalueMap.containskey(totalobj)){
                positionObj = idvsposvalueMap.get(totalobj);
            }
            positionObj.Total_JA__c = pidvsTotalJobapp.get(totalobj) != null ? pidvsTotalJobapp.get(totalobj) : 0;
            idvsposvalueMap.put(totalobj,positionObj);*/        
/*Position__c positionObj = new Position__c();
            positionObj.Id = totalobj;
            if (idvsposvalueMap.containskey(totalobj)){
                positionObj = idvsposvalueMap.get(totalobj);
            }
            positionObj.Total_Open_Pos__c = pidvsOpencount.get(totalobj) != null ? pidvsOpencount.get(totalobj) : 0;
            idvsposvalueMap.put(totalobj,positionObj);*/
/*Position__c positionObj = new Position__c();
            positionObj.Id = totalobj;
            if (idvsposvalueMap.containskey(totalobj)){
                positionObj = idvsposvalueMap.get(totalobj);
            }
            positionObj.Total_Close_Pos__c = pidvsClosecount.get(totalobj) != null ? pidvsClosecount.get(totalobj) : 0;
            idvsposvalueMap.put(totalobj,positionObj);*/
/*
 system.debug('===== in execute total job application ====='+j);
system.debug('===== in execute total job application size ====='+j.size());
 system.debug('===== inside open if not Null id jobj.Position__c ====='+jobj.Position__c);
 system.debug('===== inside open if not Null value before inc pidvsOpencount.get(jobj.Position__c) ====='+pidvsOpencount.get(jobj.Position__c));
  system.debug('===== inside open if not Null value After inc pidvsOpencount.get(jobj.Position__c) ====='+pidvsOpencount.get(jobj.Position__c));
   system.debug('===== inside open else Null value After inc pidvsOpencount.get(jobj.Position__c) ====='+pidvsOpencount.get(jobj.Position__c));
 system.debug('===== inside open =====');
 system.debug('===== inside close if Null id jobj.Position__c ====='+jobj.Position__c);
   system.debug('===== inside close if not Null value before inc pidvsClosecount.get(jobj.Position__c) ====='+pidvsClosecount.get(jobj.Position__c));
 system.debug('===== inside close if not Null value before inc pidvsClosecount.get(jobj.Position__c) ====='+pidvsClosecount.get(jobj.Position__c));
 system.debug('===== inside close Else Null value After inc pidvsClosecount.get(jobj.Position__c) ====='+pidvsClosecount.get(jobj.Position__c));
 system.debug('===== ----- execute Open job App Map ----- ====='+pidvsOpencount);
 system.debug('===== ----- execute Close job App Map ----- ====='+pidvsClosecount);
  system.debug('\n ===== inside finish open job App Map ====='+pidvsOpencount);
        system.debug('\n ===== inside finish Close job App Map ====='+pidvsClosecount);

*/