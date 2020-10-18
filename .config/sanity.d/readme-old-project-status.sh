function sanity_readme_has_old_project_status() {
	[[ -f README.md ]] || {
		report debug "No README found, skipping check"
		return 0
	}

	grep -q 'd2o84fseuhwkxk.cloudfront.net' README.md || {
		report success "No old project status found"
		return 0
	}

	report error "README contains old project status"
	return 1
}
