function sanity_makefile_contains_autohook() {
	[[ -f Makefile ]] || {
		report debug "No Makefile found, skipping check"
		return 0
	}

	grep '^auto-hook-' Makefile || {
		report success "No auto-hooks found"
		return 0
	}

	report error "Makefile contains auto-hooks"
	return 1
}
