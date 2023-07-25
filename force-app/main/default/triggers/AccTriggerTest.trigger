trigger AccTriggerTest on Account (before insert) {
    For(Account acc:Trigger.New){
        acc.Name= 'Resonant '+ acc.Name;       
    }
}