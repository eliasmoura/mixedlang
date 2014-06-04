########################
#   Client inicialization
########################

Meteor.startup ->
    Hooks.init {updateFocus:3000}
    @siteName = 'Mixed Languages'
    if Meteor.user()
        Session.set 'login', true
        Session.set 'locale', Meteor.user().profile.site_lang
    else
        Session.set 'locale', 'en_US'
    Session.set 'group-finder', false
    Session.set 'login', true
    Session.set 'add_user', false
    Session.set 'user_modal_actions', false
    Session.set 'emails', false
    Session.set("langs",[
            {lang:mf("akan",null,"Akan")},
            {lang:mf("amharic",null,"Amharic")},
            {lang:mf("arabic",null,"Arabic")},
            {lang:mf("assamese",null,"Assamese")},
            {lang:mf("awadhi",null,"Awadhi")},
            {lang:mf("azerbaijani",null,"Azerbaijani")},
            {lang:mf("balochi",null,"Balochi")},
            {lang:mf("belarusian",null,"Belarusian")},
            {lang:mf("bengali",null,"Bengali")},
            {lang:mf("bhojpuri",null,"Bhojpuri")},
            {lang:mf("burmese",null,"Burmese")},
            {lang:mf("cantonese",null,"Cantonese")},
            {lang:mf("cebuano",null,"Cebuano")},
            {lang:mf("chewa",null,"Chewa")},
            {lang:mf("chhattisgarhi",null,"Chhattisgarhi")},
            {lang:mf("chittagonian",null,"Chittagonian")},
            {lang:mf("czech",null,"Czech")},
            {lang:mf("deccan",null,"Deccan")},
            {lang:mf("dhundhari",null,"Dhundhari")},
            {lang:mf("dutch",null,"Dutch")},
            {lang:mf("english",null,"English")},
            {lang:mf("french",null,"French")},
            {lang:mf("fula",null,"Fula")},
            {lang:mf("gan",null,"Gan")},
            {lang:mf("german",null,"German")},
            {lang:mf("greek",null,"Greek")},
            {lang:mf("gujarati",null,"Gujarati")},
            {lang:mf("haitian creole",null,"Haitian Creole")},
            {lang:mf("hakka",null,"Hakka")},
            {lang:mf("haryanvi",null,"Haryanvi")},
            {lang:mf("hausa",null,"Hausa")},
            {lang:mf("hiligaynon",null,"Hiligaynon")},
            {lang:mf("hindi",null,"Hindi")},
            {lang:mf("hmong",null,"Hmong")},
            {lang:mf("hungarian",null,"Hungarian")},
            {lang:mf("igbo",null,"Igbo")},
            {lang:mf("ilokano",null,"Ilokano")},
            {lang:mf("italian",null,"Italian")},
            {lang:mf("japanese",null,"Japanese")},
            {lang:mf("javanese",null,"Javanese")},
            {lang:mf("jin",null,"Jin")},
            {lang:mf("kannada",null,"Kannada")},
            {lang:mf("kazakh",null,"Kazakh")},
            {lang:mf("khmer",null,"Khmer")},
            {lang:mf("kinyarwanda",null,"Kinyarwanda")},
            {lang:mf("kirundi",null,"Kirundi")},
            {lang:mf("konkani",null,"Konkani")},
            {lang:mf("korean",null,"Korean")},
            {lang:mf("kurdish",null,"Kurdish")},
            {lang:mf("madurese",null,"Madurese")},
            {lang:mf("magahi",null,"Magahi")},
            {lang:mf("maithili",null,"Maithili")},
            {lang:mf("malagasy",null,"Malagasy")},
            {lang:mf("malay/indonesian",null,"Malay/Indonesian")},
            {lang:mf("malayalam",null,"Malayalam")},
            {lang:mf("mandarin",null,"Mandarin")},
            {lang:mf("marathi",null,"Marathi")},
            {lang:mf("marwari",null,"Marwari")},
            {lang:mf("min bei",null,"Min Bei")},
            {lang:mf("min dong",null,"Min Dong")},
            {lang:mf("min nan",null,"Min Nan")},
            {lang:mf("mossi",null,"Mossi")},
            {lang:mf("nepali",null,"Nepali")},
            {lang:mf("oriya",null,"Oriya")},
            {lang:mf("oromo",null,"Oromo")},
            {lang:mf("pashto",null,"Pashto")},
            {lang:mf("persian",null,"Persian")},
            {lang:mf("polish",null,"Polish")},
            {lang:mf("portuguese",null,"Portuguese")},
            {lang:mf("punjabi",null,"Punjabi")},
            {lang:mf("quechua",null,"Quechua")},
            {lang:mf("romanian",null,"Romanian")},
            {lang:mf("russian",null,"Russian")},
            {lang:mf("saraiki",null,"Saraiki")},
            {lang:mf("serbo-croatian",null,"Serbo-Croatian")},
            {lang:mf("shona",null,"Shona")},
            {lang:mf("sindhi",null,"Sindhi")},
            {lang:mf("sinhalese",null,"Sinhalese")},
            {lang:mf("somali",null,"Somali")},
            {lang:mf("spanish",null,"Spanish")},
            {lang:mf("sundanese",null,"Sundanese")},
            {lang:mf("swahili",null,"Swahili")},
            {lang:mf("swedish",null,"Swedish")},
            {lang:mf("sylheti",null,"Sylheti")},
            {lang:mf("tagalog",null,"Tagalog")},
            {lang:mf("tamil",null,"Tamil")},
            {lang:mf("telugu",null,"Telugu")},
            {lang:mf("thai",null,"Thai")},
            {lang:mf("turkish",null,"Turkish")},
            {lang:mf("ukrainian",null,"Ukrainian")},
            {lang:mf("urdu",null,"Urdu")},
            {lang:mf("uyghur",null,"Uyghur")},
            {lang:mf("uzbek",null,"Uzbek")},
            {lang:mf("vietnamese",null,"Vietnamese")},
            {lang:mf("wu",null,"Wu")},
            {lang:mf("xhosa",null,"Xhosa")},
            {lang:mf("xiang",null,"Xiang")},
            {lang:mf("yoruba",null,"Yoruba")},
            {lang:mf("zhuang",null,"Zhuang")},
            {lang:mf("zulu",null,"Zulu")},
        
            ])  
    
Hooks.onGainFocus = ->
    if Meteor.user()
        Meteor.users.update {_id:Meteor.userId}, {$set:{"profile.status":Meteor.user().profile.default_status}}
Hooks.onLoseFocus = ->
    console.log Meteor.user()
    if Meteor.user()
        if Meteor.user().profile.default_status is 'online'
            Meteor.users.update {_id:Meteor.userId}, {$set:{"profile.status":"away"}}
