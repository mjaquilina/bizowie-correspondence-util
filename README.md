bizowie-correspondence-util

---

Command-line utility that, given API credentials for a Bizowie ERP instance and a correspondence template number,
downloads the template to a local file, then monitors it for changes and pushes those changes back up to the
Bizowie ERP instance via the API.

It's useful for quickly testing out changes to correspondence templates based on HTML or Microsoft Word documents,
without re-uploading the template document repeatedly.
