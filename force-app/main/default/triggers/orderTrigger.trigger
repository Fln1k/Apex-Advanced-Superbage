/**
 * @name orderTrigger
 * @description
 **/

trigger orderTrigger on Order (after update) {

    if (Trigger.new != null) {
      orderTriggerHelper.AfterUpdate(Trigger.new, Trigger.old);
    }
  
  }