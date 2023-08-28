@RestResource(urlMapping='/accountOperations/*')
global with sharing class AccountRestResource {

    @HttpPost
    global static String createAccount(String name, String phoneNumber, String emailAddress, String residentialAddress) {
        Account newAccount = new Account(
            Name = name,
            Phone = phoneNumber,
            Email__c = emailAddress,
            Residential_Address__c = residentialAddress
        );
        insert newAccount;
        return 'Account created with Id: ' + newAccount.Id;
    }

   @HttpGet
global static Account getAccountById() {
    RestRequest req = RestContext.request;
    String accountId = req.params.get('accountId');
    System.debug('Account Id from query parameter: ' + accountId);

    Account resultAccount = [SELECT Id, Name, Phone, Email__c, Residential_Address__c FROM Account WHERE Id = :accountId LIMIT 1];
    System.debug('Result Account: ' + resultAccount);

    return resultAccount;
}

    @HttpPatch
global static String updateAccount(String accountId, String fieldToUpdate, String updatedValue) {
    RestResponse res = RestContext.response;

    // Verify if the provided field is valid
    if (fieldToUpdate != 'Name' && fieldToUpdate != 'Phone' && fieldToUpdate != 'Email' && fieldToUpdate != 'ResidentialAddress') {
        res.statusCode = 400; 
        return 'Invalid field to update';
    }

    Account accToUpdate;
    try {
        accToUpdate = [SELECT Id, Name, Phone, Email__c, Residential_Address__c FROM Account WHERE Id = :accountId LIMIT 1];
    } catch (QueryException e) {
        res.statusCode = 404; 
        return 'Account not found';
    }

    
    if (fieldToUpdate == 'Name') {
        accToUpdate.Name = updatedValue;
    } else if (fieldToUpdate == 'Phone') {
        accToUpdate.Phone = updatedValue;
    } else if (fieldToUpdate == 'Email') {
        accToUpdate.Email__c = updatedValue;
    } else if (fieldToUpdate == 'ResidentialAddress') {
        accToUpdate.Residential_Address__c = updatedValue;
    }

    update accToUpdate;

    return 'Account updated';
}

    @HttpDelete
global static String deleteAccount() {
    RestRequest req = RestContext.request;
    String accountId = req.params.get('accountId');
    System.debug('Account Id from query parameter: ' + accountId);

    Account accToDelete;
    try {
        accToDelete = [SELECT Id FROM Account WHERE Id = :accountId LIMIT 1];
    } catch (QueryException e) {
        System.debug('Error: ' + e);
        return 'Account not found';
    }

    delete accToDelete;

    return 'Account deleted';
}

}