public class CandidateViewExtension {
    public id CanID{get;set;}
    public Candidate__c candidateObj{get;set;}
    public list<candidateWrapper> candidateWrapperlist{get;set;}
    
    public CandidateViewExtension(ApexPages.StandardController controller) {
        candidateObj = (Candidate__c)controller.getrecord();
        system.debug('----- candidateObj -----'+candidateObj );
        system.debug('----- candidateObj  id -----'+candidateObj.id);
        list<Candidate__c> candidateList = [select id,name,Age__c,Education__c,Email_Id__c,First_Name__c,Last_Name__c from Candidate__c where id =:candidateObj.id ];
        if(candidateList != null && candidateList.size()>0){
            system.debug('----- candidateList size -----' +candidateList.size());
            candidateObj = candidateList.get(0);
            candidateWrapperlist = new list<candidateWrapper>();
            list<Job_Application__c> ListOfJobApp = [select id,name,Job_status__c from Job_Application__c where Candidate__c =: candidateObj.id ];
            for(Job_Application__c ObjJob : ListOfJobApp ){
                candidateWrapper ObjWrap = new candidateWrapper();
                
                ObjWrap.JobAppObj = ObjJob;
                candidateWrapperlist.add(ObjWrap);
            }
        }
    }
    public class candidateWrapper{
        public Job_Application__c JobAppObj{get;set;}
    }

}