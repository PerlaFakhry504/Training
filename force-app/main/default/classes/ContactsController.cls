public with sharing class ContactsController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(Id accId) {
        return [
            SELECT Id, FirstName, LastName, Email, Phone
            FROM Contact
            WHERE AccountId = :accId
        ];
    }

    @AuraEnabled
    public static Contact updateContact(Contact cntct) {
        update cntct;
        return cntct;
    }
}
