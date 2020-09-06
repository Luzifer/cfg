function sanity_lint_pkgbuild() {
	[[ -f PKGBUILD ]] || {
		report debug "No PKGBUILD file found, skipping check"
		return 0
	}

	command -v namcap 2>&1 >/dev/null || {
		report warn "PKGBUILD found but 'namcap' utility not available"
		return 0
	}

	local output=$(namcap -i PKGBUILD)
	local errors=$(echo "${output}" | grep -c " E: ")
	local warns=$(echo "${output}" | grep -c " W: ")

	[ $errors -eq 0 ] || {
		report error "'namcap PKGBUILD' found $errors errors and $warns warnings"
		return 1
	}

	[ $warns -eq 0 ] || {
		report warn "'namcap PKGBUILD' found $warns warnings"
		return 0
	}

	report success "'namcap PKGBUILD' found no errors or warnings"
}

function sanity_lint_pkgbuild_result() {
	[[ -f PKGBUILD ]] || {
		report debug "No PKGBUILD file found, skipping check"
		return 0
	}

	local packages=($(find . -name '*.pkg.tar.xz' -or -name '*.pkg.tar.zst'))
	[ ${#packages[@]} -gt 0 ] || {
		report warn "PKGBUILD but no *.pkg.tar.xz or *.pkg.tar.zst found, skipping check"
		return 0
	}

	local retcode=0
	local nosuccess=0
	for pkg in "${packages[@]}"; do
		local output=$(namcap -i "${pkg}")
		local errors=$(echo "${output}" | grep -c " E: ")
		local warns=$(echo "${output}" | grep -c " W: ")

		[ $errors -eq 0 ] || {
			report error "'namcap ${pkg}' found $errors errors and $warns warnings"
			nosuccess=1
			retcode=1
		}

		[ $warns -eq 0 ] || {
			report warn "'namcap ${pkg}' found $warns warnings"
			nosuccess=1
		}
	done

	[ $nosuccess -eq 1 ] || report success "No errors or warnings found in built packages"
	return $retcode
}
