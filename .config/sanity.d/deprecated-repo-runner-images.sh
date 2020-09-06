function sanity_deprecated_reporunner_images() {
	[[ -f .repo-runner.yaml ]] || {
		report debug "No Repo-Runner config found, skipping check"
		return 0
	}

	grep 'quay.io/luzifer/' .repo-runner.yaml || {
		report success "No Quay image found in Repo-Runner config"
		return 0
	}

	report error "Repo-Runner config contains old Quay image"
	return 1
}
