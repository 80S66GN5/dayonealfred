on alfred_script(q)
	-- Set what comes before the link in your entry
	set prefix to "Reading "
	-- Set what comes after the link in your entry, use `\n\n` to put comments on new line
	set separator to " "
	-- Set what separates the link and the clipboard text
	set quoteSeparator to " ooooo "
	
	set entry to ""
	set feedback to "NO SCRIPT RAN!"
	set starred to False
	
	tell application "Safari"
		set theTitle to name of front document
		set theURL to URL of front document
	end tell
	
	if q is equal to ""
		-- Without Comment or Star
		set urlStr to prefix & "[" & theTitle & "](" & theURL & ")"
		set entry to urlStr
		set feedback to theTitle
	else if character 1 of q is equal to "!"
		-- Starred Entries
		if q is equal to "!"
			-- Without Comment
			set urlStr to prefix & "[" & theTitle & "](" & theURL & ")"
			set entry to urlStr
			set starred to True
			set feedback to "☆ " & theTitle
		else
			-- With Comment
			set urlStr to prefix & "[" & theTitle & "](" & theURL & ")" & separator
			set croppedQ to text 3 through -1 of q
			set entry to urlStr & croppedQ
			set starred to True
			set feedback to "☆ " & theTitle & separator & croppedQ
		end if
	else if character 1 of q is equal to "q"
		-- Quote Entries
		set clippy to the clipboard
		if q is equal to "q"
			-- Without Star
			set urlStr to prefix & "[" & theTitle & "](" & theURL & ")"
			set entry to urlStr & quoteSeparator & clippy
			set feedback to theTitle & "\n>" & clippy
		else if charcter 2 of q is equal to "!"
			-- With Star 
			set urlStr to prefix & "[" & theTitle & "](" & theURL & ")"
			set entry to urlStr & quoteSeparator & clippy
			set starred to True
			set feedback to "☆ " & theTitle & "\n>" & clippy
		else
			-- Anything else, ignore star
			set urlStr to prefix & "[" & theTitle & "](" & theURL & ")"
			set entry to urlStr & quoteSeparator & clippy
			set feedback to theTitle & "\n>" & clippy
		end if
	else
		-- Unstarred, with Comment
		set urlStr to prefix & "[" & theTitle & "](" & theURL & ")" & separator
		set entry to urlStr & q
		set feedback to theTitle & separator & q	
	end if

	try
		if starred is True
			do shell script "echo \"" & entry & "\" | /usr/local/bin/dayone --starred=true new"
		else
			do shell script "echo \"" & entry & "\" | /usr/local/bin/dayone new"
		end if
	on error errMsg
		set feedback to "ERROR! " & errMsg
	end try
	return feedback
end alfred_script