public with sharing class Exercise4 {
    public static void createOffers(List<Offer__c> newList, Map<Id, Offer__c> oldMap) {
        Map<Id, List<Offer__c>> oppIdsToOffersMap = new Map<Id, List<Offer__c>>();
        for (Offer__c offr : newList) {
            if (oldMap == null || oldMap.get(offr.Id).Opportunity__c != offr.Opportunity__c) {
                if (offr.Opportunity__c != null) {
                    if (!oppIdsToOffersMap.containsKey(offr.Opportunity__c)) {
                        oppIdsToOffersMap.put(offr.Opportunity__c, new List<Offer__c>());
                    }
                    oppIdsToOffersMap.get(offr.Opportunity__c).add(offr);
                }
            }
        }
        if (oppIdsToOffersMap.isEmpty()) {
            return;
        }
      
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity> (
            [ SELECT Identifier__c, TECH_Offer_Count__c FROM Opportunity WHERE Id IN :oppIdsToOffersMap.keySet() ]
        );
        
        for (Id oppId : oppIdsToOffersMap.keySet()) {
            Opportunity parent = oppMap.get(oppId);
            if (parent == null) continue;
            
            String base = parent.Identifier__c != null
                          ? parent.Identifier__c
                          : '';
            Integer cnt = parent.TECH_Offer_Count__c != null
                          ? parent.TECH_Offer_Count__c.intValue()
                          : 0;
            
            for (Offer__c child : oppIdsToOffersMap.get(oppId)) {
                cnt++;
                child.Offer_Identifier__c = base + '-' + cnt;
            }
        }
    }
}
