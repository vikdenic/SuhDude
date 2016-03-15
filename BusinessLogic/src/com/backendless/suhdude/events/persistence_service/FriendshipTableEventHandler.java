package com.backendless.suhdude.events.persistence_service;

import com.backendless.BackendlessUser;
import com.backendless.servercode.ExecutionResult;
import com.backendless.servercode.RunnerContext;
import com.backendless.servercode.annotation.Asset;
import com.backendless.suhdude.models.Friendship;

import java.util.List;

/**
* FriendshipTableEventHandler handles events for all entities. This is accomplished
* with the @Asset( "Friendship" ) annotation. 
* The methods in the class correspond to the events selected in Backendless
* Console.
*/
    
@Asset( "Friendship" )
public class FriendshipTableEventHandler extends com.backendless.servercode.extension.PersistenceExtender<Friendship>
{

  @Override
  public void afterCreate( RunnerContext context, Friendship friendship, ExecutionResult<Friendship> result ) throws Exception
  {
      if (!friendship.getGroup()) {
          List<BackendlessUser> members = friendship.getMembers();
          for (int i = 0; i < members.size(); i++) {
              BackendlessUser user = members.get(i);
              List<BackendlessUser> friends = (List<BackendlessUser>) user.getProperty("friends");

              if (i == 0) {
                  friends.add(members.get(1));
              } else {
                  friends.add(members.get(0));
              }

              user.setProperty("friends", user.getProperty("friends"));

              System.out.println(user.getProperty("name").toString());
          }
      }
  }

}
        