public class SobjectUpdateBatch implements Database.Batchable<SObject>,database.stateful{
    
    Public List<SObject> sobjList = new List<SObject>();
    public SobjectUpdateBatch(List<Sobject> sobjList){
        this.sobjList = sobjList;
    }
    
    Public Iterable<SObject> start(Database.BatchableContext Bc){
        return sobjList;
    }
    
    Public void execute(Database.BatchableContext bc,list<sObject> sobjlist){
        system.debug('=====SobjectUpdateBatch====='+sobjlist);
        /*for(id objpos : sobjlist.id){
            
        }*/
        if(sobjlist.size() > 0){
            update sobjlist;
        }
    }
    
    Public void finish(Database.BatchableContext bc){  
        
    }
}