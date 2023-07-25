trigger trigAmount on Policy__c (after update) 
{
List<Policy__c> polList=new List<Policy__c>();
Double value=0.00;
Double diff=0.0;
for(Policy__c p: Trigger.new)
{
value=p.Amount__c;
for(Policy__c r: Trigger.old)
{

 if(p.AccountId__c==r.AccountId__c)
{
polList.add(r);
}
}
}
Integer size=polList.size();
for(Policy__c q: polList)
{
Double total=q.Amount__c*(size+1);
diff=(total-value)/size;


}
double d0=0.00;
 List<Policy__c> polList1=new List<Policy__c>();


for(Policy__c p:Trigger.old)
{
polList1.add(p);
}
integer s=polList.size();
for(Policy__c q:Trigger.old)
{
if(q.Amount__c!=polList1[s-1].Amount__C && q.Amount__C!=polList1[s-2].Amount__C && q.Amount__C!=polList1[s-3].Amount__C)
        delete polList1;



}

}