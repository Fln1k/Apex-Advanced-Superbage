public class orderHelper {
/**
	 * @name AfterUpdate
	 * @description
	 * @param List<Order> newList
	 * @param List<Order> oldList
	 * @return void
	 **/
	public static void afterUpdate(List<Order> newList, List<Order> oldList){
		Set<Id> activatedOrderIds = new Set<Id>();
		for (Integer i = 0; i < newList.size(); i++){
			if ((newList[i].Status == Constants.ACTIVATED_ORDER_STATUS && newList[i].ActivatedDate != null) && oldList[i].Status == Constants.DRAFT_ORDER_STATUS){
				activatedOrderIds.add(newList[i].Id);
			}
		}
		RollUpOrderItems(activatedOrderIds);
	}

	public static void rollUpOrderItems(Set<Id> activatedOrderIds){
		Map<Id, Product2> productMap = new Map<Id, Product2>();
		Set<Id> productIds = new Set<Id>();
		List<OrderItem> items = [SELECT Id, Product2Id, Quantity
		                         FROM OrderItem
                                 WHERE OrderId In :activatedOrderIds
                                 WITH SECURITY_ENFORCED];
		for (OrderItem oi : items){
			productIds.add(oi.Product2Id);
		}
		productMap = new Map<Id, Product2>([SELECT Id, Quantity_Ordered__c
		                                    FROM Product2
                                            WHERE Id IN :productIds
                                            WITH SECURITY_ENFORCED]);
		AggregateResult[] groupedResults = [SELECT Product2Id, SUM(Quantity)activatedQuantity
		                                    FROM OrderItem
                                            WHERE Product2Id In :productMap.keySet()
                                            WITH SECURITY_ENFORCED
                                            GROUP BY Product2Id];
		for (AggregateResult ar : groupedResults){
			productMap.get((String)ar.get('Product2Id')).Quantity_Ordered__c = Double.valueOf(ar.get('activatedQuantity'));
		}
		if (productMap != null && productMap.size() > 0){
			update productMap.values();
		}
	}
}
