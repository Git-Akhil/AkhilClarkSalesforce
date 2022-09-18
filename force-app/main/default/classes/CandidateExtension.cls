public class CandidateExtension {
    
    public id CandidateID{get;set;}
    public Candidate__c candidate{get;set;}
    public list<JobApplicationWrap> JobApplicationWrapList{get;set;}
    
    public CandidateExtension(ApexPages.StandardController controller) {
        CandidateID = ApexPages.CurrentPage().getparameters().get('id');
        system.debug('----- CandidateID -----'+CandidateID);
        
        
        list<Candidate__c> candidateList = [select id,name,Age__c,Email_Id__c,Education__c,First_Name__c,Last_Name__c from Candidate__c where id =:CandidateID];
        if(candidateList != null && candidateList.size()>0){
            candidate = candidateList.get(0);
            JobApplicationWrapList = new list<JobApplicationWrap>();
            
            list<Job_Application__c> jobAppList = [select id,Name,Job_status__c,Candidate__c from Job_Application__c where Candidate__c=:CandidateID ];
            system.debug('------ jobAppList ------'+jobAppList);
            for(Job_Application__c JOb: jobAppList){
                JobApplicationWrap Wrapper = new JobApplicationWrap();
                Wrapper.JobApp = JOb;
                Wrapper.checkBox = false;
                JobApplicationWrapList.add(Wrapper);
            }
        }
    }
    
    public void Updaterecord(){
        list<Job_Application__c> UpdateCandidateList = new List<Job_Application__c>();
        for(JobApplicationWrap WRAPObj: JobApplicationWrapList){
            if(WRAPObj.checkBox){
                UpdateCandidateList.add(WRAPObj.JobApp);
            }
        }
        update candidate;
        update UpdateCandidateList;
    }
    
    public class JobApplicationWrap{
        public boolean checkBox{get;set;}
        public Job_Application__c JobApp{get;set;}
    }
    
    @testVisible
    private List<String> getFieldsList(){
        
        List<String> fldList = new List<String>();
        fldList.add('Name');
        fldList.add('Age__c');
        fldList.add('Email_Id__c');
        fldList.add('Education__c');
        fldList.add('First_Name__c');
        fldList.add('Last_Name__c');
        
        return fldList;
    }
    
}