#####################
#   Chat routines
#####################

_.extend Template.chat,
    events:
        'click button.correctionWraper': (e,t) ->
            elementClass = $(e.target).attr 'class'
            if elementClass.indexOf('ok') is -1
                $(e.target).popover 'show'
                $(e.target).addClass 'ok'
            return 
            

    rendered: ->
        document.title = 'Chat - #{siteName}'
        $('body').ready ->
            $('#testediv').css('height',o)
            $('#testediv').css('height',$('#layout').height() - $('.chat-input').height() - $('.chat-input').height() *1.1)
            return 
        $(window).resize ->
            $('#testediv').css('height',0)
            $('#testediv').css('height',$('.chat-input').height() - $('.chat-input').height() - $('.chat-input').height() *1.1)
            return 

_.extend Template.chatrooms,
    events:
        'a'

    rendered: ->
        'a'

    correct: ->
        Session.get 'correct'

_.extend Template.chat_input,
    events:
        'keydown textarea#message': (event,template) ->
            if event.which == 13 #return key
                message = template.find '#message'
                if message.value isnot ''
                    Meteor.call 'send_message', message.value
                    message.value = ''
                    return
                return 
           
_.extend Template.chatrooms_side,
    events:
        'click a.chat-room': (event,template) ->
            Meteor.call 'setRoom_active', event.target.id
            return 
        'click a.chat-group': (event,template) ->
            Meteor.call 'setGroup_active', event.target.id
            return 
        'click a.friends-contacts': (event,template) ->
            Meteor.call 'setFriend_active', event.target.id
            return
        'click a.panel-rooms': (event, template) ->
            $('##{$(event.target).attr("data-toggle-to")}').collapse('toggle')
            event.preventDefault
            'collapse'
        'click span#add-find-chat': (event,template) ->
            Session.set 'group-finder', true
            Session.set 'find-create-group', true
            return 
        'click span.conf': (event,template) ->
            Session.set 'group-conf', event.target.id
            return 
        'click span#add-find-user': (event,template) ->
            Session.set 'find_user', true
            return

    rendered: ->
        $('body').ready ->
            $('.sidebar').css 'height', 0
            $('.sidebar').css 'height', $('#layout').height() * 0.8
            return
        $(window).resize ->
            $('.sidebar').css 'height', 0
            $('.sidebar').css 'height', $('#layout').height() * 0.8
            return
    find_chat_group: ->
        Session.get 'group-finder'
    requests: ->
        userId = Meteor.userId()
        mygroupRequests = Group.find {owner: userId}, {fields:{request:1, _id: 1, name: 1}}
        groupRequests = Groups.find {mod:{$in:[userID]}}
        total = mygroupRequests.count() + groupRequests.count()
        {
        myGroup: mygroupRequests.fetch()
        group: groupRequests.fetch()
        total: total
        } 
