function sanity_has_readme() {
	[[ -f README.md ]] || {
		report error "No README.md found"
		return 1
	}

	report success "README.md found"
}
