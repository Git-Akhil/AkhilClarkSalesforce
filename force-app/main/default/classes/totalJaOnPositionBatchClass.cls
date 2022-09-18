public class totalJaOnPositionBatchClass Implements Database.Batchable<sobject>,Database.stateful{
    public Map<id,decimal> pidvsTotalJobappNew = new map<id,decimal>();
    public map<id,decimal> pidvsOpencountNew = new map<id,decimal>();
    public map<id,decimal> pidvsClosecountNew = new map<id,decimal>();
    
    public Database.QueryLocator Start(Database.BatchableContext Bc){
        return Database.GetQueryLocator('Select id,name,Total_JA__c,Total_Close_Pos__c,Total_Open_Pos__c,(Select id,name,Job_status__c,Position__c from Job_Applications__r) from Position__c');
    }
    public void Execute(Database.BatchableContext bc,List<Position__c> poList){
        For(Position__c posobj1 : poList){
            
            if(posobj1.Job_Applications__r != Null && posobj1.Job_Applications__r.size() > 0){
                For(Job_Application__c job1 : posobj1.Job_Applications__r){
                    if(pidvsTotalJobappNew.containsKey(posobj1.id)){ 
                        decimal TotalJacount = pidvsTotalJobappNew.get(posobj1.id); 
                        pidvsTotalJobappNew.put(posobj1.id,TotalJacount+1);
                    }
                    else{
                        pidvsTotalJobappNew.put(posobj1.id,1);
                    }
                }
            }
            else{
                pidvsTotalJobappNew.put(posobj1.id,0);
            }
        }
        For(Position__c posobj : poList){
            if(posobj.Job_Applications__r != Null && posobj.Job_Applications__r.size() > 0){
            	
                integer oflag=0,cflag =0;
                
                For(Job_Application__c job : posobj.Job_Applications__r ){
                    
                    if(job.Job_status__c == 'Open'){
                        
                        oflag++;
                        
                        if(pidvsOpencountNew.containsKey(posobj.Id)){
                            decimal opencount = pidvsOpencountNew.get(job.Position__c); 
                            pidvsOpencountNew.put(posobj.Id, opencount+1);
                        }
                        else pidvsOpencountNew.put(posobj.Id, 1); 
                    }
                    else if(job.Job_status__c == 'Close'){
                       
                        cflag++;
                       
                        if(pidvsClosecountNew.containsKey(posobj.Id)){ 
                           decimal Closecount = pidvsClosecountNew.get(job.Position__c); 
                           pidvsClosecountNew.put(posobj.Id, Closecount+1);
                       }
                       else pidvsClosecountNew.put(posobj.Id, 1); 
                    }
                    
                    /*else{
                        system.debug('else inside after open close');
                        pidvsOpencountNew.put(posobj.Id, 0);
                        pidvsOpencountNew.put(posobj.Id, 0);
                    }*/
                    
                } 
                if(oflag == 0){
                    system.debug('inside open flag 0');
                    pidvsOpencountNew.put(posobj.Id, 0); 
               
                }
                if(cflag == 0){
                    system.debug('inside close flag 0');
                     pidvsClosecountNew.put(posobj.Id, 0);
                }
            }
            else { 
                pidvsOpencountNew.put(posobj.Id, 0); 
                pidvsClosecountNew.put(posobj.Id, 0); 
            }
        }
    }
    public void Finish(Database.BatchableContext bc){
        System.debug('===== Finish total job count map ====='+pidvsTotalJobappNew +'\n ===== Finish Open count map ====='+pidvsOpencountNew +'\n===== Finish Close count map ====='+pidvsClosecountNew );} 
}

/*system.debug('===== in execute List<Position__c> po ====='+po);
        system.debug('===== in execute List<Position__c> po size ====='+po.size());
 system.debug('===== in side for if not null job app list ====='+posobj1.Job_Applications__r);
                system.debug('===== in side for if not null job app list size ====='+posobj1.Job_Applications__r.size());
system.debug('===== in side for else null job app list ====='+posobj1.Job_Applications__r);
  System.debug('===== in side for else Total Ja count map ====='+pidvsTotalJobappNew);
 System.debug('===== Execute Total Ja count map ====='+pidvsTotalJobappNew);
        System.debug('===== Execute Open count map ====='+pidvsOpencountNew);
        System.debug('===== Execute Close count map ====='+pidvsClosecountNew);

*/