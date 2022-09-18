public class CandidatestaticCont {
	public string assignCandidateID{get;set;}
    public list<Candidate__c> getCandidateRecord(){
        return [select id,name,Age__c,Education__c,Email_Id__c,First_Name__c,Last_Name__c from Candidate__c where id =: assignCandidateID];
    } 
}