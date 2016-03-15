
package com.backendless.suhdude;

import com.backendless.Backendless;
import com.backendless.servercode.IBackendlessBootstrap;
import com.backendless.suhdude.models.Friendship;


public class Bootstrap implements IBackendlessBootstrap
{
            
  @Override
  public void onStart()
  {
    Backendless.setUrl( "https://api.backendless.com" );
    Backendless.initApp("FCC9E18B-C20B-0C59-FFE0-E931AC63F400", "5F9DA2B2-ADDB-0DF3-FF82-9A993B1DD700", "v1");

    Backendless.Persistence.mapTableToClass("Friendship", Friendship.class);
    // add your code here
  }
    
  @Override
  public void onStop()
  {
    // add your code here
  }
    
}
        