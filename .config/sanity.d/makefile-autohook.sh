function sanity_makefile_contains_autohook() {
	report debug "Check for auto-hook in Makefile"

	[[ -f Makefile ]] || {
		report debug "No Makefile found"
		return 0
	}

	grep '^auto-hook-' Makefile || {
		report success "No auto-hooks found"
		return 0
	}

	report error "Makefile contains auto-hooks"
	return 1
}
