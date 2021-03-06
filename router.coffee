Router.configure 
    layoutTemplate: 'layout',
    notFoundTemplate: 'notFound',
    loadingTemplate: 'loading'


Router.map ->
    @route 'home',{
        path: '/',
        template: 'home',
        yieldTemplates: 'home-side': to: 'sidebar',
        onBeforeAction: ->
            if not Meteor.user
                #render login templete but keep the URL
                @render 'notFound'
                @pause
            
        }
    @route 'chatrooms',{
        path: 'chat',
        yieldTemplates: 'chatrooms_side': to: 'sidebar',
        fastRender: true,
        waitOn: ->
            if Meteor.user 
                [
                    Meteor.subscribe 'chatrooms-list'
                    Meteor.subscribe 'user-chatroom-list'
                    Meteor.subscribe 'privatechat'
                    Meteor.subscribe 'chat-messages', Meteor.user().profile.active_room
                    Meteor.subscribe 'chat-correction', Meteor.user().profile.active_room
                    Meteor.subscribe 'user-groups-list', User_Group.findOne user: Meteor.userId
                    Meteor.subscribe 'languages-list'
                    Meteor.subscribe 'requests'
                    Meteor.subscribe 'request-invite'
                    Meteor.subscribe 'user-groups'
                    Meteor.subscribe 'user-list'
                    Meteor.subscribe 'user-contact'
                    Meteor.subscribe 'emails-received'
                    ]
        onBeforeAction: ->
        
        OnAfterAction: ->
            modal_action = Session.get 'user_modal_actions'
            if Session.get('emails').send isnt undefined
                Meteor.call 'find', user:_id:Session.get('emails').user, (error,users)->
                    if users
                        Session.set 'emails',{
                            send:'action',
                            user:users
                        }
             
            if modal_action.action is "add"
                Meteor.call 'find', user:_id:modal_action.user, (error,users) ->
                    if users
                        Session.set 'user_modal_actions',{
                        add: true
                        action: 'Add contact'
                        user:users.profile
                        _id:users._id
                        }
                    else
                        console.log 'erro while trying to send a friendship reques'
                        
            if modal_action.action is "invite"
                Meteor.call 'find', user:_id:modal_action.user, (error, users)->
                if users
                    Session.set 'user_modal_action',{
                    group:true
                    action: 'Invite #{users.profile.name} to:'
                    name:users.profile.name
                    _id:users._id
                    } 
            if modal_action.action is "profile"
                Meteor.call 'find', user:_id:modal_action.user, (error,users) ->
                    if users
                        Session.set 'user_modal_actions',{
                        profile: true
                        action: "#{users.profile.name} #{users.profile.lastname}"
                        user: users.profile
                        _id: users._id
                        }
            if modal_action.action is "report"
                Meteor.call 'find', user:_id:modal_action.user, (error, users) ->
                    if users
                        Session.set "user_modal_action", {
                        report: true
                        action:'Report user'
                        name: users.profile.name
                        _id: users._id
                        }
        data:
            rooms: ->
               rooms = Chatrooms.find {}, {sort:{name:1}}
               rooms.forEach (row) ->
                    if row._id is Meteor.user.profile.active_room.room
                        row.active = true
                    roomsArray.push row
            room: ->
                if Meteor.userId
                    room = Meteor.user.profile.active_room
                    if room.type is "public"
                        room = Chatrooms.findOne _id:room.room
                    else if room.type is "group"
                        room = Groups.findOne _id: room.room
                    else if room.type is "privatechat"
                        user = PrivateChat.findOne(_id: room.room).contact
                        user = Meteor.users.findOne _id: user
                        room = name:user.profile.name
                room
            chat_users: ->
                Deps.autorun ->
                    Meteor.call "user_list", Meteor.user.profile.active_room, (error, result) ->
                        if not error
                            Session.set "chat_users", result
                Session.get "chat_users"
            contacts: ->
                users_relationsArray = []
                users_relations = UsersRelations.find {}
                users_relations.forEach (row) ->
                    privatechat = PrivateChat.findOne contact: row.contact
                    user = Meteor.users.findOne _id:row.contact
                    if privatechat.new_messages
                        user.notification = privatechat.new_messages
                        user.active = privatechat.active
                    users_relationsArray.push user
                    user
                users_relationsArray
            messages: ->
                messages = Meteor.user.profile.active_roo
                if messages.type is "public"
                    messages = Messages.find room: messages.room
                else if messages.type is "group"
                    messages = GroupChat.find groupchat:messages.room
                else if messages.type is "private"
                    messages = PrivateMessages.find chat:$in:[messages.room]
                blocked_users = Meteor.user.profile.blocked_users
                messages.forEach (row) ->
                    if blocked_users.indexOf row.userid is -1
                        corrections = Correction.find message:row._id
                        corrections.forEach (row) ->
                                crow.corrector = Meteor.users.findOne({_id:crow.correctori}).profile.name
                        row.correction.push crow
                    messagesArray.push row
                messagesArray
            activeChat: "active"
}
