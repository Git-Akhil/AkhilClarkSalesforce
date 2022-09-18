public class customController{
        public List<selectOption> openPositionlist{
        get{
            list<selectOption> returnOpenPositions = new list<selectOption>();
            string positionInfo;
            for(Position__c p : [select name,Job_Description__c,Department__c,Status__c from Position__c ]){
                positionInfo = p.name + ' - ' + p.Job_Description__c + ' - ' + p.Department__c +' - '+ p.Status__c  ;
                returnOpenPositions.add(new selectOption(p.id,positionInfo ));
            }
            return returnOpenPositions ;
        }
        set;
        }
        
        Public List<selectOption> jobApplicationCandidates{
        get{
             List<selectOption> candidates = new List<selectOption>();
             for(Job_Application__c JA : [select Candidate__r.id,Candidate__r.First_Name__c,Candidate__r.Last_Name__c,Job_status__c from Job_Application__c where (Position__r.id = :selectedPosition.id) and (Job_status__c = 'Open' )]){
                 candidates.add(new selectOption(JA.id,JA.Candidate__r.First_Name__c+ ' ' +JA.Candidate__r.Last_Name__c ));
             }
             return candidates;
        }
        set;
        }
        
        public id selectedjobApplication{ get; set; }
        
        public Position__c selectedPosition{
        get{
            if(selectedPosition == null){
                selectedPosition = new position__c();
            }
            return selectedPosition;
        }
        set;
        }
        
        public PageReference step2(){
              return page.InterviewScheduler2;
        }
        public PageReference step3(){
              return null;
        }
}