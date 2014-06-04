########################
# Server routines
########################

Meteor.startup ->
    if Chatrooms.find.count is 0
        console.log "adding chatrooms"
        Chatrooms.insert {name:"Test", details:"A test room"}
        Chatrooms.insert {name: "Test2", details: "Atest room"}

Accounts.onCreateUser (options,user) ->
    console.log "Creating user"
    options.profile = {} unless options.profile
    options.profile.online = true
    options.profile.away = false
    options.profile.active_room = {type:null,room:null}
    options.profile.default_status = "online"
    options.profile.site_lang = "en_US"
    #user.profile = options.profile
    user.srp = options.srp
    user.profile = options.profile if options.profile
    console.log "User #{user.profile.name} #{user.profile.lastname} created"
    console.log user

Hooks.onLoggedIn = (userId) ->
    Meteor.users.update {_id:Meteor.userId}, {$set:{"profile.status":Meteor.user().profile.default_status}}
Hooks.onLoggedOut = (userId) ->
    if Meteor.user
        Meteor.users.update {_id:Meteor.userId}, {$set:{"profile.status":"offline"}}
