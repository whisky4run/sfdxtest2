global class SandboxRecordGenerator implements SandboxPostCopy {
    
    private String accName1 = 'チームA';
    private String accName2 = 'チームB';
    
    global void runApexClass (SandboxContext context) {
    
        insertProductModel();
        insertStockMaster();
        insertAccount();
        insertContact();
    }
    
    private void insertProductModel () {
        List<ProductModelMaster__c> pcmArray = new List<ProductModelMaster__c>();
    
        ProductModelMaster__c pcm1 = new ProductModelMaster__c (
            name='PC_その1',
            Cost__c=500,
            ProductType__c='PC'        
        );
        pcmArray.add (pcm1);
        
        ProductModelMaster__c pcm2 = new ProductModelMaster__c (
            name='マウス_その1',
            Cost__c=50,
            ProductType__c='マウス'
        );
        pcmArray.add (pcm2);
        
        ProductModelMaster__c pcm3 = new ProductModelMaster__c (
            name='キーボード_その1',
            Cost__c=70,
            ProductType__c='キーボード'
        );
        pcmArray.add (pcm3);
        
        
        insert pcmArray;
    }
    
    private void insertStockMaster () {
        List<StockMaster__c> stcArray = new List<StockMaster__c>();
        
        String pcname1='PC_その1';
        ProductModelMaster__c pdm1 = Database.query ('SELECT Id FROM ProductModelMaster__c WHERE name = :pcname1');
        
        if (pdm1 != null) {
            StockMaster__c stm1 = new StockMaster__c (
                name='PC1',
                Amount__c=10,
                ProductModel__c=pdm1.Id
            );
            stcArray.add (stm1);
        }
            
        String mousename1='マウス_その1';
        ProductModelMaster__c pdm2 = Database.query ('SELECT Id FROM ProductModelMaster__c WHERE name = :mousename1');
        
        if (pdm2 != null) {
            StockMaster__c stm2 = new StockMaster__c (
                name='Mouse1',
                Amount__c=5,
                ProductModel__c=pdm2.Id
            );
            stcArray.add (stm2);
        }
            
        String kbdname1='キーボード_その1';
        ProductModelMaster__c pdm3 = Database.query ('SELECT Id FROM ProductModelMaster__c WHERE name = :kbdname1');

        if (pdm3 != null) {
            StockMaster__c stm3 = new StockMaster__c (
                name='Keyboard1',
                Amount__c=20,
                ProductModel__c=pdm3.Id
            );
            stcArray.add (stm3);
        }       
        
        if (stcArray.size() > 0){
            insert stcArray;
        }
    }
    
    private void insertAccount() {
        List<Account> accArray = new List<Account>();
        
        Account acc1 = new Account(name = accName1);
        accArray.add (acc1);
        Account acc2 = new Account(name = accName2);
        accArray.add (acc2);
        insert accArray;
    }
    
    private void insertContact() {
        List<Contact> conArray = new List<Contact>();
     
        Account acc1 = Database.query ('SELECT Id FROM Account WHERE name = :accName1');
        
        if (acc1 != null) {
            Contact con1 = new Contact(LastName = '担当者1', Account = acc1);
            conArray.add (con1);
        }
        
        Account acc2 = Database.query ('SELECT Id FROM Account WHERE name = :accName2');
        
        if (acc2 != null) {
            Contact con2 = new Contact(lastname = '担当者2', Account = acc2);
            conArray.add (con2);
        }
     
        if (conArray.size() > 0){       
            insert conArray;         
        }
    }
    
    
}