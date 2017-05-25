global class SandboxRecordGenerator2 implements SandboxPostCopy {
    // Account name.
    static final String accName1 = 'チームA';
    static final String accName2 = 'チームB';
    
    // ProductModelMaster__c.ProductType__c (Picklist)
    static final String pickTypePC		= 'PC';
    static final String pickTypeKbd		= 'キーボード';
    static final String pickTypeMouse	= 'マウス';
    static final String pickTypeDisplay	= 'ディスプレイ';
    static final String pickTypeOther	= 'その他';
    
    static final List<String> prdNames = new List<String>{	'PC_その1',
    														'マウス_その1', 
    														'キーボード_その1',
    														'ディスプレイ_その1',
    														'電源アダプタ_X'
    														};
    static final List<Integer> stkAmounts = new List<Integer> {25, 105, 90, 35, 170};
    
    global void runApexClass (SandboxContext context) {
        List<inputProductModel> prdArray = new List<inputProductModel>();
    
    
    
        insertProductModel(prdArray);
        insertStockMaster(prdArray);
        insertAccount();
        insertContact();
    }
    
    class inputProductModel {
    	String	inpName;
    	Integer	inpCost;
    	String	inpType;
    	
    	inputProductModel (String name, Integer cost, String type){
    		inpName	= name;
    		inpCost	= cost;
    		inpType = type;
    	}
    }
    
    class inputStockMaster {
    	String	inpName;
    	Integer	inpAmount;
    	Id		inpProdId;
    	
    	inputStockMaster (String name, Integer amount, Id prodId){
    		inpName	= name;
    		inpAmount = amount;
    		inpProdId = prodId;	
    	}
    }
    
    private void insertProductModel (List<inputProductModel> prdArray) {
        List<ProductModelMaster__c> pcmArray = new List<ProductModelMaster__c>();
        
        // Records for ProductModelMaster__c
        prdArray.add (new inputProductModel (prdNames[0], 500, pickTypePC));
        prdArray.add (new inputProductModel (prdNames[1], 150, pickTypeMouse));
        prdArray.add (new inputProductModel (prdNames[2], 170, pickTypeKbd));
        prdArray.add (new inputProductModel (prdNames[3], 230, pickTypeDisplay));
        prdArray.add (new inputProductModel (prdNames[4],  50, pickTypeOther));
        
        for (inputProductModel i : prdArray){
        	pcmArray.add (new ProductModelMaster__c (name=i.inpName, Cost__c=i.inpCost, ProductType__c=i.inpType));
        }
    
		if (pcmArray.size() > 0){ 	
	        insert pcmArray;			
		}       
    }
    
    private void insertStockMaster (List<inputProductModel> prdArray) {
        List<StockMaster__c> stcArray = new List<StockMaster__c>();
        List<inputStockMaster> inpstArray = new List<inputStockMaster>();
        Integer idx = 0;

		for (inputProductModel i : prdArray){
			String stType = i.inpType;
			ProductModelMaster__c prd = Database.query ('SELECT Id, Name, ProductType__c FROM ProductModelMaster__c WHERE ProductType__c = :stType');
			if (prd != null){
				inpstArray.add (new inputStockMaster (prd.Name + '_Stk', stkAmounts[idx++], prd.Id));
			}
		}
		
		for (inputStockMaster is : inpstArray){
			stcArray.add (new StockMaster__c (name=is.inpName, Amount__c=is.inpAmount, ProductModel__c=is.inpProdId));
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
            Contact con1 = new Contact(LastName = '担当者1', AccountId = acc1.Id);
            conArray.add (con1);
        }
        
        Account acc2 = Database.query ('SELECT Id FROM Account WHERE name = :accName2');
        
        if (acc2 != null) {
            Contact con2 = new Contact(lastname = '担当者2', AccountId = acc2.Id);
            conArray.add (con2);
        }
     
        if (conArray.size() > 0){       
            insert conArray;         
        }
    }
    
    
}