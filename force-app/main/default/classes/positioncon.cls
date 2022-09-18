public with sharing class positioncon {

    public PageReference Cancel() {
        return null;
    }


    public positioncon() {

    }

    
    public id positionID{get;set;}
    public Position__c pos{get;set;}
    public list<Jobappwrapper> jobWrapperList{get;set;}
    public string forpagesec1{get;set;}
    public boolean Rendervalue{get;set;}
    
    public positioncon(ApexPages.StandardController controller) {
        positionID = ApexPages.currentpage().getparameters().get('id');
        system.debug('----- positionID  -----'+positionID );
        forpagesec1 = 'cunstructor called';
        Rendervalue = false;
        
        list<Position__c> postitionList = [select id,name,Start_Date__c,location__c,Job_Description__c,Hiring_Manager__c,Department__c,Education_Requri__c,Status__c,Sub_status__c,Programming_Language__c from Position__c where id = :positionID ];
        if(postitionList != null && postitionList.size()>0){
        
            pos = postitionList.get(0);
            system.debug('----- pos.id -----'+pos.id);
            jobWrapperList = new list<Jobappwrapper>();
            
            list<Job_Application__c> listofJobAppliction = [select id,Name,Job_status__c,Position__c from Job_Application__c where  Position__c =: pos.id ];
            system.debug('-----listofJobAppliction -----'+listofJobAppliction );
            
            for(Job_Application__c  job : listofJobAppliction ){
                system.debug('===== job.id ====='+job.id);
                system.debug('===== job.Position__c ====='+job.Position__c);
                Jobappwrapper Obj = new Jobappwrapper();
                obj.isselected = false;
                obj.JobApplicationObject = job;
                jobWrapperList.add(Obj);
            }
            system.debug('-----jobWrapperList -----'+jobWrapperList.size() );
            
        }    
    }
    public void saverecord(){
        system.debug('-----jobWrapperList -----'+jobWrapperList );
        
        list<Job_Application__c> updateJObAppList = new list<Job_Application__c>();
        forpagesec1 = 'saverecord called';
        Rendervalue = true;
        
        for(Jobappwrapper UpdateJOb : jobWrapperList){
            
            system.debug('-----jobWrapperList isselected -----'+UpdateJOb.isselected);
            system.debug('-----jobWrapperList JobApplicationObject-----'+UpdateJOb.JobApplicationObject.Name);
            if(UpdateJOb.isselected){
                updateJObAppList.add(UpdateJOb.JobApplicationObject);
            }
        }
        update pos;
        update updateJObAppList;
    }
    public class Jobappwrapper
        {
            public boolean isselected{get;set;}
            public Job_Application__c JobApplicationObject{get;set;}
        }

   

}