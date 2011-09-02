$ ->
	$key = $('#key')
	$word = $('#word')
	$to = $('#to')
	$result = $('#results')
	$submit = $('#submit')
	$scripts = $('#scripts')

	languages =
		'''
		Afrikans=af
		Albanian=sq
		Arabic=ar
		Belarusian=be
		Bulgarian=bg
		Catalan=ca
		Chinese Simplified=zh-CN
		Chinese Traditional=zh-TW
		Croation=hr
		Czech=cs
		Danish=da
		Dutch=nl
		English=en
		Estonian=et
		Filipino=tl
		Finissh=fi
		French=fre
		Galician=gl
		German=de
		Greek=el
		Haitian Creole=ht
		Hebrew=iw
		Hindi=hi
		Hungarian=hu
		Icelandic=is
		Indonesian=id
		Irish=ga
		Italian=it
		Japanese=ja
		Latvian=lv
		Lithuanian=lt
		Macedonian=mk
		Malay=ms
		Maltese=mt
		Norwegian=no
		Persian=fa
		Polish=pl
		Portuguese=pt
		Romainian=ro
		Russion=ru
		Serbian=sr
		Slovak=sk
		Slovenian=sl
		Spanish=es
		Swahili=sw
		Swedish=sv
		Thai=th
		Turkish=tr
		Ukrainian=uk
		Vietnamese=vi
		Welsh=cy
		Yiddish=yi
		'''
	
	languages = languages.split(/\n/g)
	languageCodes = {}

	for language in languages
		parts = language.split('=')
		name = parts[0]
		code = parts[1]
		languageCodes[code] = name

		$to.append """
			<option value="#{code}">#{name}</option>
			"""

		$result.append """
			<div id="#{code}"><label>#{name}:</label> <span class="value"><span></div>
			"""
		
		$to.find('[value=en]').attr('selected',true)
	
	translateText = (from,to,response) ->
		selector = '#'+from+' .value'
		$el = $(selector).removeClass('different same')
		word = $word.val()

		try
			text = response.data.translations[0].translatedText
		catch err
			text = word
		
		if text isnt word
			$el.addClass('different')
		else
			$el.addClass('same')
		
		$el.html(text)
		#console.log "[#{from}] to [#{to}] = [#{text}] | [#{selector}]", response
	
	$submit.click ->
		$('.value').text '...'

		key = escape $key.val()
		to = escape $to.val()
		word = escape $word.val()

		unless to and key and word
			alert 'you need to specify a to language, a key, and a word'
			return

		$scripts.empty()
		
		for own from, value of languageCodes
			from = escape from
			callbackName = escape "translate#{from}to#{to}".replace('-','')
			window[callbackName] = ((from,to) -> (response) -> translateText(from,to,response))(from,to)
			if from is to
				window[callbackName]()
			else
				$scripts.append """
					<script src="https://www.googleapis.com/language/translate/v2?key=#{key}&source=#{from}&target=#{to}&callback=#{callbackName}&q=#{word}"></script>
					"""



