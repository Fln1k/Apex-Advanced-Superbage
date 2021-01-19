/**
 * @name orderTrigger
 * @description
 **/

trigger orderTrigger on Order (after update) {

    if (Trigger.new != null) {
      orderHelper.afterUpdate(Trigger.new, Trigger.old);
    }
  
  }