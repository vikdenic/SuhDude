package com.backendless.suhdude.models;

import com.backendless.Backendless;
import com.backendless.BackendlessUser;
import com.backendless.geo.GeoPoint;

public class Friendship
{
  private java.util.List<BackendlessUser> members;
  private Boolean group;
  private Double suhCount;
  private Boolean sendPush;
  private java.util.Date updated;
  private String ownerId;
  private java.util.Date lastSent;
  private BackendlessUser lastSender;
  private String blockers;
  private java.util.Date created;
  private String objectId;

  public java.util.List<BackendlessUser> getMembers()
  {
    return this.members;
  }

  public Boolean getGroup()
  {
    return this.group;
  }

  public Double getSuhCount()
  {
    return this.suhCount;
  }

  public Boolean getSendPush()
  {
    return this.sendPush;
  }

  public java.util.Date getUpdated()
  {
    return this.updated;
  }

  public String getOwnerId()
  {
    return this.ownerId;
  }

  public java.util.Date getLastSent()
  {
    return this.lastSent;
  }

  public BackendlessUser getLastSender()
  {
    return this.lastSender;
  }

  public String getBlockers()
  {
    return this.blockers;
  }

  public java.util.Date getCreated()
  {
    return this.created;
  }

  public String getObjectId()
  {
    return this.objectId;
  }


  public void setMembers( java.util.List<BackendlessUser> members )
  {
    this.members = members;
  }

  public void setGroup( Boolean group )
  {
    this.group = group;
  }

  public void setSuhCount( Double suhCount )
  {
    this.suhCount = suhCount;
  }

  public void setSendPush( Boolean sendPush )
  {
    this.sendPush = sendPush;
  }

  public void setUpdated( java.util.Date updated )
  {
    this.updated = updated;
  }

  public void setOwnerId( String ownerId )
  {
    this.ownerId = ownerId;
  }

  public void setLastSent( java.util.Date lastSent )
  {
    this.lastSent = lastSent;
  }

  public void setLastSender( BackendlessUser lastSender )
  {
    this.lastSender = lastSender;
  }

  public void setBlockers( String blockers )
  {
    this.blockers = blockers;
  }

  public void setCreated( java.util.Date created )
  {
    this.created = created;
  }

  public void setObjectId( String objectId )
  {
    this.objectId = objectId;
  }

  public Friendship save()
  {
    return Backendless.Data.of( Friendship.class ).save( this );
  }

  public Long remove()
  {
    return Backendless.Data.of( Friendship.class ).remove( this );
  }

  public static Friendship findById( String id )
  {
    return Backendless.Data.of( Friendship.class ).findById( id );
  }

  public static Friendship findFirst()
  {
    return Backendless.Data.of( Friendship.class ).findFirst();
  }

  public static Friendship findLast()
  {
    return Backendless.Data.of( Friendship.class ).findLast();
  }
}