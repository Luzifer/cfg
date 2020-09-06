function sanity_year_placeholder_in_license() {
	report debug "Check for [year] placeholder in LICENSE file"

	[[ -f LICENSE ]] || {
		report warn "No LICENSE file found"
		return 0
	}

	grep '\[year\]' LICENSE || {
		report success "No placeholder found"
		return 0
	}

	report error "LICENSE file contains [year] placeholder"
	return 1
}
