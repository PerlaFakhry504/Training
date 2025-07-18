public with sharing class Exercise3 {
    public static void validateCompetitor (List<Competitor__c> newList , Map<Id,Competitor__c> oldMap){
        Set<Id> accountsLinkedToOppSet = new Set<Id>();
        Set<Id> accountsLinkedToQuoteSet = new Set<Id>();
        for( Competitor__c cmptr : newList ){
            if( cmptr.Account__c != NULL){

                if(cmptr.Opportunity__c != NULL && cmptr.Quote__c == NULL ) {
                accountsLinkedToOppSet.add(cmptr.Account__c); }

                 if(cmptr.Opportunity__c == NULL && cmptr.Quote__c != NULL ) {
                accountsLinkedToQuoteSet.add(cmptr.Account__c); }
            }  
        }
        List<Competitor__c> existingAccountsLinkedToOppList =[SELECT Account__c FROM Competitor__c WHERE Account__c IN : accountsLinkedToOppSet ];
        List<Competitor__c> existingAccountsLinkedToQuoList =[SELECT Account__c FROM Competitor__c WHERE Account__c IN : accountsLinkedToQuoteSet ];
        

        Set<Id> accountsToStop = new  Set<Id> ();

        for(Competitor__c cmp : existingAccountsLinkedToOppList){
            accountsToStop.add(cmp.Account__c); }

        for(Competitor__c cmp : existingAccountsLinkedToQuoList){
           accountsToStop.add(cmp.Account__c); 
        } 
        
        for (Competitor__c cmp : newList) {
            if (accountsToStop.contains(cmp.Account__c)) {
                cmp.addError('Cannot Add Account');
            }
        }

        // for (Competitor__c cmp : newList) {
        //     if( oldMap!=null 
        //             && 
        //         cmp.Account__c != cmp.oldMap.get(cmp.Id).Account__c 
        //             &&
        //         (   
        //             (cmp.Opportunity__c != cmp.oldMap.get(cmp.Id).Opportunity__c )
        //                 ||
        //             (cmp.Quote__c != cmp.oldMap.get(cmd.Id).Quote__c)

        //         )   
        //       )
        // }

    }

    public static void addCompetitor(List<Competitor__c> newList , Map<Id,Competitor__c> oldMap)
    { //after insert after update so 3eyzin l ids so fina 
     //nest3ml NEW MAP KRML jib  ID_OF_Competitor_YLE_N5ALA2.account__c 
     // ta bas ana e3ml a new competitor e5la2o aa hayda l account bl zet 

     Map<Id,Id >QuoteToAccountmap = new Map<Id,Id >();

     for(Competitor__c comp : newList) {
        QuoteToAccountmap.put(comp.Quote__c , comp.Account__c);
     }

     Set<Id> quoteIdsSet = new Set<Id>();
     quoteIdsSet = QuoteToAccountmap.keySet();

    List<Quote__c> OppIds = new List<Quote__c>();
    
    OppIds = [ SELECT Opportunity__c FROM Quote__c WHERE Id IN : quoteIdsSet ] ;

    List <Competitor> competitorsToAdd = new List <Competitor>();

    // for (competitor cmp : newList) {
    //     Competitor c = new Competitor();
    //     c.account__c = cmp.account__c;
    //     c.Opportunity__c =  mn yle jebton bl query yeene cmp.quote__c.opportunity__c , 
    //     competitorsToAdd.add(c);
    // }

    //database.insert(competitorsToAdd , False);
    

        }

}