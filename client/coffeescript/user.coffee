trimInput = (val) ->
    val.replace /^\s*|\s*$/g, ""
isValidPassword = (val, field) ->
    if val.length is 6
        true
        'password ok'
    else
        false
        mf 'passwd-erro',null,'Error password must have at least 6 characters' 

_.extend Template.user,
    events:
        'click a#logoutButton': (event, template) ->
            Meteor.logout()
            return 
        'click #profile': (event,template) ->
            Session.set 'user_modal_action',{
            profile: true
            action: '#{Meteor.user().profile.name} #{Meteor.user().profile.lastname}'
            user: Meteor.user().profile
            _id: Meteor.userId
            }
        'click #email': (event, template) ->
            Session.set 'emails', {sent: 'actiove'}
            return
        'click #notification': (event, template) ->
            $('#notificationModal').modal 'toggle'
            return 
        'click #userstatus': (event, template) ->
            event.prevantDefault()
            event.stopPropagation()

            elementClass = $(event.target).attr 'class'

            if elementClass.indexOf('ok') is -1
                    status = '<div><a href="#" class="setuserstatus" id="online"><span class="online glyphicon glyphicon-ser"></span> #{mf("online",null,"Online")}<a/></div> 
                               <div><a href="#" class="setuserstatus" id="away"> <span class="away glyphicon glyphicon-user"></span> #{mf("away",null,"away")}<a/></div>
                               <div><a href="#" class="setuserstatus" id="busy"> <span class="busy glyphicon glyphicon-user"></span> #{mf("busy",null,"Busy")}<a/></div>'
                    target = event.target
                    $(target).popover {
                        html: true
                        title: "<h4> #{mf 'set-status',null,'Set status'}:</h4>"
                        content: status
                        placement: 'bottom'
                        }
                    $(target).popover 'show'
                    $(target).addClass 'ok'
                    $('.popover').on 'click', '.setuserstatus', ->
                        pop = $('#userstatus')
                        status = $(this).attr 'id'
                        Meteor.call 'set_userStatus', status
                        $(pop).popover 'hide'
                        return 
            return 
    login: ->
        Session.get 'login'
    first_login: -> 
        Session.get 'first-login'

_.extend Template.login_form,
    events:
        'submit form.login-form': (event,template) ->
            event.preventDefault()
            email = template.find('#login_email').value
            passwd = template.find('#login_passwd').value
            email = trimInput email
            Meteor.loginWithPassword email, passwd, (error) ->
                if error
                    #throw new Meteor.Error 111, "couldn't find your email or password!"
                    console.log 'error'
                    return false
                console.log 'login ok'
            return 
        'click a.newUser': (event, template) ->
            Session.set 'login', false
            return 
        'click span#login-submit': (event,template) ->
            $('form.login_form').submit()
            return
        'submit #reset-passwd-form': (event, template) ->
            event.preventDefaul()
        'click #reset-passwd-btn': (event,template) ->
            $('#reset-passwd-form').submit()
       
_.extend Template.register_form,
    events:
        'click button.register-btn': (event,template) ->
            event.preventDefault()
            name = template.find('#name_registerform').value
            lastname = template.find('#lastname_registerform').value
            gender = template.find('.gender:checked').value
            interests = template.findAll('[name=interests]:checked')
            birthday = template.find('#birthday_registerform').value
            email = template.find('#email_registerform').value
            passwdch = template.find('#passwdcheck_registerform').value
            passwd = template.find('#passwd_registerform').value
            city = template.find('#city_registerform').value
            country = template.find('#country_registerform').value
            nativelang = template.find('#native_registerform option:selected').text
            learninglanguages = template.findAll('.learning-language option:selected')
            knowlanguages = template.findAll('.knownlanguage option:selected')
            langs = new Array() 
            if learninglanguages.length > 1
                learninglanguages.forEach ->
                    lang = $(this).text()
                    if lang isnot 0
                        langs.push {lang:lang}
            else
                langs = [{lang:learninglanguages[0].text}]
            langs = new Array()
            if knowlanguages.length > 1
                knowlanguages.each ->
                    lang = $(this).text()
                    if lang isnt 0
                        knownlangs.push {lang:lang}
            else
                knownlangs = [{lang:knowlanguages[0].text}]
            interestsArray = new Array()
            if interests.length > 1
                interests.each ->
                    interestsArray.push {interest:$(this).attr 'value'}
            else
                interestsArray = [{interests:interests[0].attr 'value'}]
            email = trimInput email
            if isValidPassword passwd
                Accounts.createUser {
                email:email
                password:passwd
                profile: {
                    name:name
                    lastname:lastname
                    birthday:birthday
                    gender:gender
                    country:country
                    city:city
                    nativelang:nativelang
                    learninglanguages:langs
                    knownlanguages:knownlangs
                    interests:interestsArray
                    }
                }
                $('#registerModal').modal 'hide'
    rendered: ->
        $('#registerModal').modal 'toggle'
        $('#registerModal').on 'hidden.bs.modal', ->
            Session.set 'login', true
    destroyed: ->
        $('#registerModal').modal 'hide'
        Session.set 'first-login', true
