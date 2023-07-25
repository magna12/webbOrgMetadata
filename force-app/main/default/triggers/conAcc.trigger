trigger conAcc on Contact (After update) {
   
List<Contact>conList=new List<Contact>();
    conList=[Select Id,LastName from Contact where LastName Like '%df%'];
    For(Contact con:conList)
        con.LastName='test';
    update conList;
    System.debug('running');
    }