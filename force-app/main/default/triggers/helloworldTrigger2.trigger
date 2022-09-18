trigger helloworldTrigger2 on Account (before insert) {
    for(Account a : Trigger.new){
        a.description = ' new description ';
    }

}