#!/bin/bash

gitlab_version="14.1.1"

# sha256sum found here: https://packages.gitlab.com/gitlab
gitlab_debian_version="buster"

gitlab_x86_64_buster_source_sha256="f7a45a4b035a0ee6ebcd4330d29749d6be2819f09cf07e2fd63eec7d34e3b586"

gitlab_arm64_buster_source_sha256="2c46fea02a06528d7cf9afa8fbef7c16a82e065a299e49ee7b32f6783299852e"

gitlab_arm_buster_source_sha256="1650b646305fd3e5a0a9d6ac48ea378f06b3e40a2b948103ec567490a25e62e0"

architecture=$(ynh_app_setting_get --app="$app" --key=architecture)

if [ "$architecture" = "x86-64" ]; then
	gitlab_source_sha256=$gitlab_x86_64_buster_source_sha256
elif [ "$architecture" = "arm64" ]; then
	gitlab_source_sha256=$gitlab_arm64_buster_source_sha256
elif [ "$architecture" = "arm" ]; then
	# If the version for arm doesn't exist, then use an older one
	if [ -z "$gitlab_arm_buster_source_sha256" ]; then
		gitlab_version="14.1.1"
		gitlab_arm_buster_source_sha256="1650b646305fd3e5a0a9d6ac48ea378f06b3e40a2b948103ec567490a25e62e0"
	fi
	gitlab_source_sha256=$gitlab_arm_buster_source_sha256
fi

gitlab_filename="gitlab-ce-${gitlab_version}.deb"

# Action to do in case of failure of the package_check
package_check_action() {
	ynh_backup_if_checksum_is_different --file="$config_path/gitlab.rb"
	cat <<EOF >> "$config_path/gitlab.rb"
# Last chance to fix Gitlab
package['modify_kernel_parameters'] = false
EOF
	ynh_store_file_checksum --file="$config_path/gitlab.rb"
}
