trigger Tr1 on Account (after insert) {
    for(Account a: Trigger.new)
    {
        for(integer i=1;i<=a.NO_of_policies__c;i++)
        {
            Policy__c po=new Policy__c();
            po.name=a.name+'p'+i;
            po.AccountId__c=a.Id;
            po.Amount__c=a.Amount__c/a.NO_of_policies__c;
            insert po;
        }
    }
}