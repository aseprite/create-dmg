on run (volumeName)
	tell application "Finder"
		tell disk (volumeName as string)
			log "open"
      open
      log "close"
      close
    end tell
	end tell
end run
