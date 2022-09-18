public class JobApplictionCompCont {
    public id assignPositionID{get;set;}
    public string assignCandidateID{get;set;}
    public list<Job_Application__c> getJobApplicationRecord(){
        return [select id,name,Job_status__c,Candidate_Qualified__c,count_of_app__c,Candidate__r.id,Candidate__r.Name from Job_Application__c where Position__c =: assignPositionID];
    }
    public list<Candidate__c> getCandidateRecord(){
        return [select id,name,Age__c,Education__c,Email_Id__c,First_Name__c,Last_Name__c from Candidate__c where id =: assignCandidateID];
    } 
}