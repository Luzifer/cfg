function sanity_has_funding() {
	[[ -f .github/FUNDING.yml ]] || {
		report warn "No FUNDING.yml config found"
		return 0
	}

	report success "FUNDING.yml found"
}
