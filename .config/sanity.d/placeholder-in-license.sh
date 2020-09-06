function sanity_year_placeholder_in_license() {
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
