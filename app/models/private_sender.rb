# Copyright 2008-2010 Universidad Politécnica de Madrid and Agora Systems S.A.
#
# This file is part of VCC (Virtual Conference Center).
#
# VCC is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# VCC is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with VCC.  If not, see <http://www.gnu.org/licenses/>.

#This class will compose all the mails that the application should send

class PrivateSender
  
  def self.invitation_message(invitation)
    m = PrivateMessage.new :title => I18n.t("invitation.to_space",:space=>invitation.group.name,:username=>invitation.introducer.full_name),
      :body => invitation.comment.gsub('\'' + I18n.t('name.one') + '\'',invitation.candidate.full_name).gsub('\'' + I18n.t('url_plain') + '\'', "<a href=\"http://" + Site.current.domain + "/invitations/" + invitation.code + "\">http://" + Site.current.domain + "/invitations/" + invitation.code + "</a>")
    m.receiver = invitation.candidate
    m.save!
  end
  
  
  def self.event_invitation_message(invitation)
    m = PrivateMessage.new :title => I18n.t("invitation.to_event",:eventname=>invitation.group.name,:space=>invitation.group.space.name,:username=>invitation.introducer.full_name),
      :body => invitation.comment.gsub('\'' + I18n.t('name.one') + '\'',invitation.candidate.full_name).gsub('\'' + I18n.t('url_plain') + '\'', "<a href=\"http://" + Site.current.domain + "/invitations/" + invitation.code + "\">http://" + Site.current.domain + "/invitations/" + invitation.code + "</a>")
    m.receiver = invitation.candidate
    m.save!
  end

  
  def self.event_notification_message(event,receiver)
    m = PrivateMessage.new :title => I18n.t("event.notification.subject",:eventname=>event.name,:space=>event.space.name,:username=>(User.find(event.notif_sender_id)).full_name),
      :body => ( event.notify_msg.gsub("'Name'", receiver.full_name) + "<br/><br/>" )
    m.receiver = receiver
    m.save!
  end
  
  
  def self.performance_update_notification_message(sender,receiver,stage, rol)
    if stage.type.name == 'Space'
      m = PrivateMessage.new :title => I18n.t("performance.notification.subject.space", :username=>sender.full_name , :space=>stage.name),
      :body =>  I18n.t("performance.notification.space", :username=>sender.full_name , :space=>stage.name , :role => rol );
      m.receiver = receiver
      m.save! 
    end
  end
  
  
  def self.join_request_message(jr,receiver)
    m = PrivateMessage.new :title => I18n.t("join_request.ask_subject", :candidate => jr.candidate.name, :space => jr.group.name),
      :body => jr.comment
    m.receiver = receiver
    m.save!
  end
  
  
  def self.processed_invitation_message(invitation, receiver)
    action = invitation.accepted? ? I18n.t("invitation.yes_accepted") : I18n.t("invitation.not_accepted")
    
    if invitation.candidate != nil
      m = PrivateMessage.new :title => I18n.t("email.invitation_result.admin_side",:name=>invitation.candidate.name, :action => action, :spacename =>invitation.group.name),
        :body => "<p>" + invitation.introducer.full_name + ",</p>" +
          "<p>" + I18n.t('email.invitation_result.admin_side',:name=>invitation.candidate.full_name, :action => action, :spacename =>invitation.group.name) + ".</p>" +
          "<p>" + I18n.t('invitation.info_users', :users_url => "http://" + Site.current.domain + "/spaces/" + invitation.group.permalink + "/users") + "</p>" +
          "<p>" + Site.current.signature_in_html + "</p>"
    else
      m = PrivateMessage.new :title => I18n.t("email.invitation_result.admin_side",:name=>invitation.email, :action => action, :spacename =>invitation.group.name),
        :body => "<p>" + invitation.introducer.full_name + ",</p>" +
          "<p>" + I18n.t('email.invitation_result.admin_side',:name=>invitation.email[0,invitation.email.index('@')], :action => action, :spacename =>invitation.group.name) + ".</p>" +
          "<p>" + I18n.t('invitation.info_users', :users_url => "http://" + Site.current.domain + "/spaces/" + invitation.group.permalink + "/users") + "</p>" +
          "<p>" + Site.current.signature_in_html + "</p>" 
    end

    m.receiver = receiver
    m.save!
  end
  
  
  def self.processed_join_request_message(jr)
    action = jr.accepted? ? I18n.t("invitation.yes_accepted") : I18n.t("invitation.not_accepted")
    
    if jr.accepted?
      m = PrivateMessage.new :title => I18n.t("email.invitation_result.user_side", :action => action, :spacename =>jr.group.name),
      :body => I18n.t('email.invitation_result.user_side', :action => action, :spacename =>jr.group.name) + "<br/><br/>" +
        I18n.t('invitation.access_space', :spacename => jr.group.name, :space_url => "http://" + Site.current.domain + "/spaces/" + jr.group.permalink) + "<br/><br/>" +
        I18n.t('admin.space', :spacename => jr.group.name)
    else
      m = PrivateMessage.new :title => I18n.t("email.invitation_result.user_side", :action => action, :spacename =>jr.group.name),
      :body => I18n.t('email.invitation_result.user_side', :action => action, :spacename =>jr.group.name) + "<br/><br/>" +
        I18n.t('invitation.rejoin_space', :space_url => "http://" + Site.current.domain + "/spaces/" + jr.group.permalink + "/join_requests/new") + "<br/><br/>" +
        I18n.t('admin.space', :spacename => jr.group.name)
    end
     
    m.receiver = jr.candidate
    m.save!
  end
  
end
