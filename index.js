// Your Google Cloud Platform project ID
const [key, from = 'en', text = 'Hello world'] = process.argv.slice(2)

// Imports the Google Cloud client library
const Translate = require('@google-cloud/translate');
const translate = new Translate({ key });

// Lists available translation language with their names in English (the default).
async function main () {
	const languages = (await translate.getLanguages())[0]
	const results = await Promise.all(
		languages.map(async function ({ code, name }) {
			const to = code
			if (from === to) {
				return { code, name, translation: text }
			}
			const translation = (await translate.translate(text, { from, to }))[0]
			return {
				code,
				name,
				translation
			}
		})
	)
	results.forEach(function (result) {
		console.log(`${result.name}: ${result.translation}`)
	})
}

main()