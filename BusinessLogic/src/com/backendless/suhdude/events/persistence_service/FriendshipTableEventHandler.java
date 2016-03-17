package com.backendless.suhdude.events.persistence_service;

import com.backendless.Backendless;
import com.backendless.BackendlessUser;
import com.backendless.servercode.ExecutionResult;
import com.backendless.servercode.RunnerContext;
import com.backendless.servercode.annotation.Asset;
import com.backendless.suhdude.models.Friendship;

import java.util.ArrayList;
import java.util.Arrays;

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
//        if (!friendship.getGroup()) {
//            BackendlessUser user = friendship.getMembers().get(0);
//            BackendlessUser friend = friendship.getMembers().get(1);
//            updateFriendsForUser(user, friend);
//            updateFriendsForUser(friend, user);
//        }
    }

    public void updateFriendsForUser(BackendlessUser user, BackendlessUser friend) {

        Object[] obj = (Object[]) user.getProperty("friends");

        if (obj.length > 0) {
            BackendlessUser[] currentFriends = (BackendlessUser[]) obj;
            ArrayList<BackendlessUser> updatedList = new ArrayList<BackendlessUser>();

            updatedList.addAll(Arrays.asList(currentFriends));
            updatedList.add(friend);
            user.setProperty("friends", updatedList);

            Backendless.UserService.update(user);
        } else {
            ArrayList<BackendlessUser> newList = new ArrayList<BackendlessUser>();
            newList.add(friend);
            user.setProperty("friends", newList);

            Backendless.UserService.update(user);
        }
    }

}
        