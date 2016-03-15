package com.backendless.suhdude.events.user_service;

import com.backendless.servercode.RunnerContext;

import java.util.HashMap;
        
/**
* GenericUserEventHandler handles the User Service events.
* The event handlers are the individual methods implemented in the class.
* The "before" and "after" prefix determines if the handler is executed before
* or after the default handling logic provided by Backendless.
* The part after the prefix identifies the actual event.
* For example, the "beforeLogin" method is the "Login" event handler and will
* be called before Backendless applies the default login logic. The event
* handling pipeline looks like this:

* Client Request ---> Before Handler ---> Default Logic ---> After Handler --->
* Return Response
*/
public class GenericUserEventHandler extends com.backendless.servercode.extension.UserExtender
{
    
  @Override
  public void beforeUpdate( RunnerContext context, HashMap userValue ) throws Exception
  {
    // add your code here
    userValue.put("selected", false);
  }

}
        