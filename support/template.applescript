on run (volumeName)
	tell application "Finder"
    with timeout of 360 seconds
      tell disk (volumeName as string)
        log "open"
        open
        log "end open"

        set theXOrigin to WINX
        set theYOrigin to WINY
        set theWidth to WINW
        set theHeight to WINH

        set theBottomRightX to (theXOrigin + theWidth)
        set theBottomRightY to (theYOrigin + theHeight)
        set dsStore to "\"" & "/Volumes/" & volumeName & "/" & ".DS_STORE\""

        log "tell container window"
        tell container window
          set current view to icon view
          set toolbar visible to false
          set statusbar visible to false
          set pathbar visible to false
          set the bounds to {theXOrigin, theYOrigin, theBottomRightX, theBottomRightY}
          set statusbar visible to false
          REPOSITION_HIDDEN_FILES_CLAUSE
          set pathbar visible to false
        end tell
        log "end tell container window"

        set opts to the icon view options of container window
        log "tell opts"
        tell opts
          set icon size to ICON_SIZE
          set text size to TEXT_SIZE
          set arrangement to not arranged
        end tell
        log "end tell opts"

        BACKGROUND_CLAUSE

        -- Positioning
        POSITION_CLAUSE

        -- Hiding
        HIDING_CLAUSE

        -- Application and QL Link Clauses
        APPLICATION_CLAUSE
        QL_CLAUSE
        log "close"
        close
        log "open"
        open
        -- Force saving of the size
        log "delay 1"
        delay 1

        log "tell container window 2"
        tell container window
          set statusbar visible to false
          set pathbar visible to false
          set the bounds to {theXOrigin, theYOrigin, theBottomRightX - 10, theBottomRightY - 10}
        end tell
        log "end tell container window 2"
      end tell

      log "delay 1"
      delay 1

      log "tell disk (volumeName as string)"
      tell disk (volumeName as string)
        tell container window
          set statusbar visible to false
          set pathbar visible to false
          set the bounds to {theXOrigin, theYOrigin, theBottomRightX, theBottomRightY}
        end tell
      end tell
      log "end tell disk (volumeName as string)"

      --give the finder some time to write the .DS_Store file
      log "delay 3"
      delay 3

      set waitTime to 0
      set ejectMe to false
      log "repeat"
      repeat while ejectMe is false
        log "delay 1 inside repeat"
        delay 1
        set waitTime to waitTime + 1

        if (do shell script "[ -f " & dsStore & " ]; echo $?") = "0" then set ejectMe to true
      end repeat
      log "end repeat"
      log "waited " & waitTime & " seconds for .DS_STORE to be created."
    end timeout
	end tell
end run
